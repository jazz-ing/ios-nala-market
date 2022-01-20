//
//  EndPointType.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/12/29.
//

import Foundation

typealias RequestQuery = [String: Any]
typealias HTTPHeaders = [String: String]?

protocol EndPointType {
    
    var baseURL: String { get }
    var path: String { get }
    var query: RequestQuery { get }
    var httpMethod: HTTPMethod { get }
    var httpHeader: HTTPHeaders { get }

    func configureURL() -> URL?
}

enum HTTPMethod: String {
    case get
    case post
    case patch
    case delete
}
