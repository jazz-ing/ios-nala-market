//
//  NetworkManageable.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/01/20.
//

import Foundation

typealias SessionResult = (Result<Data, NetworkError>) -> Void

protocol NetworkManageable {
    
    func request(to endPoint: EndPointType, completion: @escaping SessionResult)
    func request(to endPoint: EndPointType, with body: BodyParameterType, completion: @escaping SessionResult)
}
