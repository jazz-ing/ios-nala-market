//
//  MarketListUseCase.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/01.
//

import Foundation

enum MarketListUseCaseError: LocalizedError {
    
    case selfNotFound
    case noMorePages
    
    var errorDescription: String? {
        switch self {
        case .selfNotFound:
            return "UseCase를 찾을 수 없습니다."
        case .noMorePages:
            return "마지막 페이지입니다."
        }
    }
}

final class MarketListUseCase: MarketListUseCaseProtocol {

    // MARK: Properties
    private let decodingManager: DecodingManager
    private let networkManager: NetworkManageable
    private(set) var isFetching = false
    private(set) var isLastPage = false
    private(set) var page = 1
    private let numberOfItems = 10

    // MARK: Initializer

    init(decodingManager: DecodingManager = DecodingManager(),
         networkManager: NetworkManageable = NetworkManager()) {
        self.decodingManager = decodingManager
        self.networkManager = networkManager
    }

    // MARK: Data fetching method

    func fetchProductList(completion: @escaping (Result<[Product], Error>) -> Void) {
        if isFetching || isLastPage {
            return
        }

        isFetching = true
        
        networkManager.request(
            to: MarketEndPoint.getProductList(page: page,numberOfItems: numberOfItems)
        ) { [weak self] result in
            switch result {
            case .success(let data):
                guard let decodedData = self?.decodingManager.decode(data, to: ProductList.self) else {
                    completion(.failure(MarketListUseCaseError.selfNotFound))
                    return
                }
                switch decodedData {
                case .success(let productList):
                    if self?.page == productList.lastPage {
                        self?.isLastPage = true
                        completion(.failure(MarketListUseCaseError.noMorePages))
                        return
                    }
                    self?.page += 1
                    completion(.success(productList.products))
                case .failure(let decodingError):
                    completion(.failure(decodingError))
                }
            case .failure(let networkError):
                completion(.failure(networkError))
            }
            self?.isFetching = false
        }
    }
}
