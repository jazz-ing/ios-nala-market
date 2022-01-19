//
//  EndPointType.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/12/29.
//

import Foundation

protocol EndPointType {
    var baseURL: String { get }
    var path: String { get }
    var query: [String: Int] { get }

    func configure() -> URL?
}
