//
//  Vendor.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/12/28.
//

import Foundation

struct Vendor: Decodable {
    let name: String
    let id: Int
    let createdDate: String
    let issuedDate: String

    enum CodingKeys: String, CodingKey {
        case name, id
        case createdDate = "created_at"
        case issuedDate = "issued_at"
    }
}
