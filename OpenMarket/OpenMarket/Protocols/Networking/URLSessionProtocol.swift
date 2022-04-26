//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/02/05.
//

import Foundation

protocol URLSessionProtocol {
    
    func dataTask(
        with: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
