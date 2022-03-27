//
//  ProductAddUseCase.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/25.
//

import Foundation

protocol ProductAddUseCaseProtocol {

    func add(product: Uploadable, completion: @escaping (Result<Product, Error>) -> Void)
}

final class ProductAddUseCase: ProductAddUseCaseProtocol {
    
    private let decodingManager: DecodingManager
    private let networkManager: NetworkManageable
    
    init(decodingManager: DecodingManager = DecodingManager(),
         networkManager: NetworkManageable = NetworkManager()) {
        self.decodingManager = decodingManager
        self.networkManager = networkManager
    }
    
    func add(product: Uploadable, completion: @escaping (Result<Product, Error>) -> Void) {
        networkManager.request(to: MarketEndPoint.postProduct,
                               with: product) { result in
            switch result {
            case .success(let data):
                let decodedData = self.decodingManager.decode(data, to: Product.self)
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
}
