//
//  ProductAddViewModel.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/25.
//

import UIKit.UIImage

final class ProductAddViewModel {
    
    enum State {
        case empty
        case appendImage(indexPath: Int)
        case add(Product)
        case error(Error)
    }

    private let encodingManager: EncodingManager
    private let useCase: ProductAddUseCaseProtocol
    private(set) var state: Observable<State> = Observable(.empty)
    private(set) var name: String?
    private(set) var descriptions: String?
    private(set) var price: String?
    private(set) var currency: String?
    private(set) var discountedPrice: String?
    private(set) var stock: String?
    private(set) var password: String?
    private(set) var images: [UIImage] = [] {
        didSet {
            switch images.count {
            case oldValue.count...:
                state.value = .appendImage(indexPath: images.count - 1)
            default:
                break
            }
        }
    }
    private(set) var product: Product {
        didSet {
            state.value = .add(product)
        }
    }

    init(encodingManager: EncodingManager = EncodingManager(),
         useCase: ProductAddUseCaseProtocol = ProductAddUseCase(),
         product: Product) {
        self.encodingManager = encodingManager
        self.useCase = useCase
        self.product = product
    }

    func addNewProduct() {
        guard let newProduct = createNewProduct() else { return }
        useCase.add(product: newProduct) { [weak self] result in
            switch result {
            case .success(let product):
                self?.product = product
            case .failure(let error):
                self?.state.value = .error(error)
            }
        }
    }

    func append(image: UIImage) {
        images.append(image)
    }

    func fillProduct(name: String?,
                     descriptions: String?,
                     price: String?,
                     discountedPrice: String?,
                     stock: String?,
                     password: String?) {
        self.name = name
        self.descriptions = descriptions
        self.price = price
        self.discountedPrice = discountedPrice
        self.stock = stock
        self.password = password
    }

    func fillProductCurrency(_ currency: String?) {
        guard let currency = currency else { return }
        self.currency = currency
    }

    private func createNewProduct() -> Uploadable? {
        let images = images.compactMap { $0.pngData() }

        guard let name = name,
              let descriptions = descriptions,
              let currency = currency,
              let price = price,
              let discountedPrice = discountedPrice,
              let stock = stock,
              let password = password else { return nil }

        let newProductParameter = PostParameter(name: name,
                                                descriptions: descriptions,
                                                currency: currency,
                                                price: Int(price) ?? .zero,
                                                discountedPrice: Int(discountedPrice) ?? .zero,
                                                stock: Int(stock) ?? .zero,
                                                password: password)
        
        let data = encodingManager.encode(newProductParameter)
        switch data {
        case .success(let data):
            return PostProductBody(parameter: data, images: images)
        case .failure(let encodingError):
            state.value = .error(encodingError)
            return nil
        }
    }
}
