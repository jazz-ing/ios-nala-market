//
//  PostParameter.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/01/24.
//

import Foundation

struct PostParameter: BodyParameterType {
    
    let name: String
    let descriptions: String
    let currency: String
    let price: Int
    let discountedPrice: Int
    let stock: Int
    let password: String

    enum CodingKeys: String, CodingKey {
        
        case name, descriptions, price, currency, stock
        case discountedPrice = "discounted_price"
        case password = "secret"
    }
}
