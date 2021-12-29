//
//  RequestType.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/12/29.
//

import Foundation

protocol RequestType {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: String { get }
    var httpHeader: [String : String]? { get }
    var httpBody: Data? { get }
    
    func configure() -> URLRequest?
}
