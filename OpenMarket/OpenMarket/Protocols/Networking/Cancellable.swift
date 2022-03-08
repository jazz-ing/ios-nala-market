//
//  Cancellable.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/08.
//

import Foundation

protocol Cancellable {
    
    func cancel()
}

extension URLSessionDataTask: Cancellable {}
