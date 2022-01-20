//
//  URLRequest+Extension.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/01/20.
//

import Foundation

extension URLRequest {
    
    init(url: URL, endPoint: EndPointType, contentType: String, httpBody: Data) {
        self.init(url: url)
        self.httpMethod = endPoint.httpMethod.rawValue.uppercased()
        self.allHTTPHeaderFields = endPoint.httpHeader
        self.addValue(contentType, forHTTPHeaderField: "Content-Type")
        self.httpBody = httpBody
    }
}
