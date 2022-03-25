//
//  ProductAddUseCase.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/25.
//

import Foundation

protocol ProductAddUseCaseProtocol {

    func add(product: BodyParameterType, completion: @escaping (Result<Product, Error>) -> Void)
}

final class ProductAddUseCase: ProductAddUseCaseProtocol {
    
    private let parsingManager: ParsingManager
    private let networkManager: NetworkManageable
    
    init(parsingManager: ParsingManager = ParsingManager(),
         networkManager: NetworkManageable = NetworkManager()) {
        self.parsingManager = parsingManager
        self.networkManager = networkManager
    }
    
    func add(product: BodyParameterType, completion: @escaping (Result<Product, Error>) -> Void) {
        networkManager.request(to: MarketEndPoint.postProduct,
                               with: product) { result in
            switch result {
            case .success(let data):
                let parsedData = self.parsingManager.parse(data, to: Product.self)
                switch parsedData {
                case .success(let product):
                    completion(.success(product))
                case .failure(let parsingError):
                    completion(.failure(parsingError))
                }
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
}
