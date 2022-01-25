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
        case id, vendorId, name, currency, price, description, bargainPrice, discountedPrice, stock
        case thumbnailURL = "thumbnail"
        case createdDate = "created_at"
        case issuedDate = "issued_at"
        case imageInformations = "images"
        case vendor = "vendors"
    }
}
