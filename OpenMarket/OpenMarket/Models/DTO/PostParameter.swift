//
//  PostParameter.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/01/24.
//

import Foundation

struct PostParameter: Codable {
    
    let name: String
    let descriptions: String
    let price: Int
    let currency: String
    let discountedPrice: Int = 0
    let stock: Int = 0
    let password: String

    enum CodingKeys: String, CodingKey {
        
        case name, descriptions, price, currency, stock
        case discountedPrice = "discounted_price"
        case password = "secret"
    }
}
