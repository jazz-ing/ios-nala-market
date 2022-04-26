//
//  ProductDetailUseCase.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/17.
//

import Foundation
import UIKit

enum ProductDetailUseCaseError: LocalizedError {
    
    case selfNotFound
    case invalidImageData
    
    var errorDescription: String? {
        switch self {
        case .selfNotFound:
            return "UseCase를 찾을 수 없습니다."
        case .invalidImageData:
            return "무효한 이미지 데이터입니다."
        }
    }
}

final class ProductDetailUseCase: ProductDetailUseCaseProtocol {

    // MARK: Properties

    private let decodingManager: DecodingManager
    private let networkManager: NetworkManageable

    // MARK: Initializer

    init(decodingManager: DecodingManager = DecodingManager(),
         networkManager: NetworkManageable = NetworkManager()) {
        self.decodingManager = decodingManager
        self.networkManager = networkManager
    }

    // MARK: Data fetching methods

    func fetchProductDetail(of id: Int, completion: @escaping (Result<Product, Error>) -> Void) {
        networkManager.request(to: MarketEndPoint.getProduct(id: id)) { [weak self] result in
            switch result {
            case .success(let data):
                guard let decodedData = self?.decodingManager.decode(data, to: Product.self) else {
                    completion(.failure(ProductDetailUseCaseError.selfNotFound))
                    return
                }
                switch decodedData {
                case .success(let product):
                    completion(.success(product))
                case .failure(let decodingError):
                    completion(.failure(decodingError))
                }
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
    
    func fetchImage(
        from urlString: String,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) -> Cancellable? {
        let task = networkManager.request(to: urlString) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(ProductDetailUseCaseError.invalidImageData))
                    return
                }
                completion(.success(image))
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
        task?.resume()
        return task
    }
}
