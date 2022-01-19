//
//  EndPoint.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/01/19.
//

import Foundation

enum EndPoint: EndPointType {

    case getProduct(id: Int)
    case getProductList(page: Int, numberOfItems: Int)
    case postProduct
    case patchProduct(id: Int)
    case deleteProduct(id: Int, password: String)

    var baseURL: String {
        return "https://market-training.yagom-academy.kr/"
    }

    var path: String {
        switch self {
        case .getProduct(let id), .patchProduct(let id):
            return "/api/products/\(id)"
        case .getProductList, .postProduct:
            return "/api/products"
        case .deleteProduct(let id, let password):
            return "/api/products/\(id)/\(password)"
        }
    }

    var query: [String: Int] {
        switch self {
        case .getProductList(let page, let numberOfItems):
            return [
                "page_no": page,
                "items_per_page": numberOfItems
            ]
        default:
            return [:]
        }
    }
}

extension EndPoint {
    func configure() -> URL? {
        var components = URLComponents(string: self.baseURL)
        components?.path = self.path
        let queryItems = self.query.map { (key: String, value: Int) -> URLQueryItem in
            let value = String(describing: value)
            return URLQueryItem(name: key, value: value)
        }
        components?.queryItems = queryItems
        return components?.url
    }
}
