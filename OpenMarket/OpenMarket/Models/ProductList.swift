//
//  ProductList.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/12/28.
//

import Foundation

struct ProductList: Decodable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let firstIndex: Int
    let lastIndex: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let products: [Product]

    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case firstIndex = "offset"
        case lastIndex = "limit"
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
        case products = "pages"
    }
}
