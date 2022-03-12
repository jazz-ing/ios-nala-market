//
//  MarketListCellViewModel.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/08.
//

import Foundation
import UIKit.UIImage

final class MarketCollectionViewCellViewModel {
    
    struct ProductData {
        let name: String
        var thumbnail: UIImage?
        let hasDiscountedPrice: Bool
        let price: String
        let discountedPrice: NSAttributedString
        let isOutOfStock: Bool
        let stock: String
    }
    
    enum State {
        case empty
        case update(MarketCollectionViewCellViewModel.ProductData)
        case error(Error)
    }

    private(set) var state: Observable<State> = Observable(.empty)
    private let useCase: ThumbnailUseCaseProtocol
    private(set) var thumbnailTask: Cancellable?
    private let product: Product

    init(useCase: ThumbnailUseCaseProtocol = ThumbnailUseCase(), product: Product) {
        self.useCase = useCase
        self.product = product
    }
    
    func setContents() {
        setTextFormats()
        setThumbnail()
    }
    
    private func setThumbnail() {
        let thumbnailURL = product.thumbnailURL
        thumbnailTask = useCase.fetchThumbnail(from: thumbnailURL) { [weak self] result in
            switch result {
            case .success(let thumbnail):
                guard case var .update(productData) = self?.state.value else { return }
                productData.thumbnail = thumbnail
                self?.state.value = .update(productData)
            case .failure(let error):
                self?.state.value = .error(error)
            }
        }
    }

    func prefetchThumbnail() {
        let thumbnailURL = product.thumbnailURL
        thumbnailTask = useCase.fetchThumbnail(from: thumbnailURL) { _ in }
    }

    func cancelThumbnailRequest() {
        thumbnailTask?.cancel()
    }

    private func setTextFormats() {
        let hasDiscountedPrice: Bool = product.discountedPrice != .zero
        let discountedPrice = hasDiscountedPrice
            ? "\(product.currency) \(product.price.priceFormatted())".strikeThrough()
            : NSAttributedString()
        let price: String = hasDiscountedPrice
            ? "\(product.currency) \(product.discountedPrice.priceFormatted())"
            : "\(product.currency) \(product.price.priceFormatted())"
        let isOutOfStock: Bool = product.stock == .zero
        let stock: String

        if isOutOfStock {
            stock = Style.outOfStockText
        } else if product.stock > Style.stockUpperLimit {
            stock = "\(Style.stockLabelPrefix) \(Style.stockUpperLimitText)"
        } else {
            stock = "\(Style.stockLabelPrefix) \(product.stock)"
        }

        let productData = ProductData(name: product.name,
                                      thumbnail: nil,
                                      hasDiscountedPrice: hasDiscountedPrice,
                                      price: price,
                                      discountedPrice: discountedPrice,
                                      isOutOfStock: isOutOfStock,
                                      stock: stock)
        state.value = .update(productData)
    }
}

// MARK: - NameSpace

extension MarketCollectionViewCellViewModel {

    private enum Style {

        static let outOfStockText: String = "품절"
        static let stockLabelPrefix: String = "재고:"
        static let stockUpperLimit: Int = 999
        static let stockUpperLimitText: String = "999+"
    }
}

