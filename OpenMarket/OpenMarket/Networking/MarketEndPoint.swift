//
//  EndPoint.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/01/19.
//

import Foundation

enum MarketEndPoint: EndPointType {

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

    var query: RequestQuery {
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

    var httpMethod: HTTPMethod {
        switch self {
        case .getProduct, .getProductList:
            return .get
        case .postProduct:
            return .post
        case .patchProduct:
            return .patch
        case .deleteProduct:
            return .delete
        }
    }

    var httpHeader: HTTPHeaders {
        switch self {
        case .getProduct, .getProductList:
            return nil
        case .postProduct, .patchProduct, .deleteProduct:
            return [
                "identifier": "3424eb5f-660f-11ec-8eff-b53506094baa"
            ]
        }
    }
}

extension MarketEndPoint {
    func configureURL() -> URL? {
        var components = URLComponents(string: self.baseURL)
        components?.path = self.path
        if let query = self.query {
            let queryItems = query.map { (key: String, value: Any) -> URLQueryItem in
                let value = String(describing: value)
                return URLQueryItem(name: key, value: value)
            }
            components?.queryItems = queryItems
        }
        return components?.url
    }
}
