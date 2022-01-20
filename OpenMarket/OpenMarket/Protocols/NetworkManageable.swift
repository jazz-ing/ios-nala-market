//
//  NetworkManageable.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/01/20.
//

import Foundation

typealias SessionResult = (Result<Data, NetworkError>) -> Void

protocol NetworkManageable {
    func fetch(from url: EndPointType, completion: @escaping SessionResult)
    func upload(_ product: PostProduct, to url: EndPointType, completion: @escaping SessionResult)
    func edit(_ product: PatchProduct, to url: EndPointType, completion: @escaping SessionResult)
    func delete(from url: EndPointType, completion: @escaping SessionResult)
}
