//
//  MarketListViewModel.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/03.
//

import Foundation

final class MarketListViewModel {

    enum State {
        case fetching
        case populated(indexPaths: [IndexPath])
        case empty
        case error(Error)
    }

    private let useCase: MarketListUseCaseProtocol
    private(set) var state: Observable<State> = Observable(.fetching)
    private(set) var products: [Product] = [] {
        didSet {
            switch products.count {
            case .zero:
                state.value = .empty
            case oldValue.count...:
                let numberOfNewItems = oldValue.count ..< products.count
                let indexPaths = numberOfNewItems.map { IndexPath(item: $0, section: .zero) }
                state.value = .populated(indexPaths: indexPaths)
            default:
                break
            }
        }
    }
    
    init(useCase: MarketListUseCaseProtocol = MarketListUseCase()) {
        self.useCase = useCase
    }
    
    func update() {
        useCase.fetchProductList { [weak self] result in
            switch result {
            case .success(let products):
                self?.products.append(contentsOf: products)
            case .failure(let error):
                self?.state.value = .error(error)
            }
        }
    }
}
