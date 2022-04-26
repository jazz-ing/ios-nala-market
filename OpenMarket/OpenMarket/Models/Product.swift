//
//  Product.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/12/28.
//

import Foundation

struct Product: Decodable {

    let id: Int
    let vendorId: Int
    let name: String
    let thumbnailURL: String
    let currency: String
    let price: Double
    let description: String?
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdDate: String
    let issuedDate: String
    let imageInformations: [ImageInformation]?
    let vendor: Vendor?

    enum CodingKeys: String, CodingKey {
        case id, name, currency, price, description, stock
        case vendorId = "vendor_id"
        case thumbnailURL = "thumbnail"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdDate = "created_at"
        case issuedDate = "issued_at"
        case imageInformations = "images"
        case vendor = "vendors"
    }
}
