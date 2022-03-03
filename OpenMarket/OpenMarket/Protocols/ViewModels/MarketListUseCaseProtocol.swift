//
//  MarketListUseCaseProtocol.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/03.
//

import Foundation

protocol MarketListUseCaseProtocol: AnyObject {
    
    var isFetching: Bool { get }
    var isLastPage: Bool { get }
    var page: Int { get }
    
    func fetchProductList(completion: @escaping (Result<[Product], Error>) -> Void)
}
