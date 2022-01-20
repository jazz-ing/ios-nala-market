//
//  PatchProduct.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/01/20.
//

import Foundation

struct PatchProduct: Encodable {
    
    let name: String?
    let descriptions: String?
    let thumbnailId: Int?
    let price: Int?
    let currency: String?
    let discountedPrice: Int?
    let stock: Int?
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case name, descriptions, price, currency, discountedPrice, stock
        case password = "secret"
    }
}
