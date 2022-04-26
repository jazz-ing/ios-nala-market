//
//  PatchParameter.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/01/24.
//

import Foundation

struct PatchParameter: BodyParameterType {
    
    let name: String?
    let descriptions: String?
    let thumbnailID: Int?
    let currency: String?
    let price: Int?
    let discountedPrice: Int?
    let stock: Int?
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case name, descriptions, price, currency, discountedPrice, stock
        case thumbnailID = "thumbnailId"
        case password = "secret"
    }
}
