//
//  MarketEndPoint.swift
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

    // MARK: URL Components

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
            return nil
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
                "identifier": "cd706a3e-66db-11ec-9626-796401f2341a"
            ]
        }
    }
}

// MARK: - URL configuring method

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
