//
//  ProductDetailViewModel.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/17.
//

import Foundation
import UIKit.UIImage

final class ProductDetailViewModel {
    
    struct ProductData {
        let name: String
        let description: String
        let hasDiscountedPrice: Bool
        let discountedPrice: NSAttributedString
        let price: String
        let isOutOfStock: Bool
        let stock: String
        let numberOfImages: Int
    }
    
    enum State {
        case fetching
        case populatedDetail(ProductData)
        case populatedImage(UIImage, Int)
        case error(Error)
    }

    private let useCase: ProductDetailUseCaseProtocol
    private let semaphore = DispatchSemaphore(value: 3)
    private(set) var state: Observable<State> = Observable(.fetching)
    private(set) var product: Product
    private(set) var images: [UIImage] = []
    private(set) var imageDataTasks: [Cancellable?] = []

    init(useCase: ProductDetailUseCaseProtocol = ProductDetailUseCase(), product: Product) {
        self.useCase = useCase
        self.product = product
    }
    
    func update() {
        self.fetchProductDetail()
        self.fetchImages()
    }
    
    private func fetchProductDetail() {
        semaphore.wait()
        useCase.fetchProductDetail(of: product.id) { [weak self] result in
            switch result {
            case .success(let product):
                self?.product = product
                self?.setTextFormats()
            case .failure(let error):
                self?.state.value = .error(error)
            }
            self?.semaphore.signal()
        }
    }
    
    private func fetchImages() {
        semaphore.wait()
        guard let images = product.imageInformations else {
            return
        }
        for image in images {
            if let index = images.firstIndex(where: { $0 == image }) {
                fetchImage(of: index, from: image.thumbnailURL)
            }
        }
    }

    private func fetchImage(of index: Int, from urlString: String) {
        let imageTask = useCase.fetchImage(from: urlString) { [weak self] result in
            switch result {
            case .success(let image):
                self?.images.append(image)
                self?.state.value = .populatedImage(image, index)
            case .failure(let error):
                self?.state.value = .error(error)
            }
            self?.semaphore.signal()
        }
        imageDataTasks.append(imageTask)
    }

    private func setTextFormats() {
        let isKRW = product.currency != Style.koreanCurrnecyText
        let currency = isKRW ? Style.koreanCurrencySign : Style.usCurrencySign
        let hasDiscountedPrice = product.discountedPrice != .zero
        let discountedPrice = hasDiscountedPrice ?
        "\(currency) \(product.price.priceFormatted())".strikeThrough() :
            NSAttributedString()
        let price = hasDiscountedPrice ?
            "\(currency) \(product.discountedPrice.priceFormatted())" :
            "\(currency) \(product.price.priceFormatted())"
        let isOutOfStock = product.stock == .zero
        let stock: String
        if isOutOfStock {
            stock = Style.outOfStockText
        } else if product.stock > Style.stockUpperLimit {
            stock = "\(Style.stockLabelPrefix) \(Style.stockUpperLimitText)"
        } else {
            stock = "\(Style.stockLabelPrefix) \(product.stock)"
        }

        let productData = ProductData(name: product.name,
                                      description: product.description ?? Style.emptyText,
                                      hasDiscountedPrice: hasDiscountedPrice,
                                      discountedPrice: discountedPrice,
                                      price: price,
                                      isOutOfStock: isOutOfStock,
                                      stock: stock,
                                      numberOfImages: product.imageInformations?.count ?? .zero)

        self.state.value = .populatedDetail(productData)
    }
}

// MARK: - NameSpaces

extension ProductDetailViewModel {

    private enum Style {

        static let koreanCurrnecyText: String = "KRW"
        static let koreanCurrencySign: String = "₩"
        static let usCurrencySign: String = "$"
        static let outOfStockText: String = "품절"
        static let stockLabelPrefix: String = "재고:"
        static let stockUpperLimit: Int = 999
        static let stockUpperLimitText: String = "999+"
        static let emptyText: String = ""
    }
}
