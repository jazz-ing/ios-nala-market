//
//  ImageInformation.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/12/28.
//

import Foundation

struct ImageInformation: Decodable {
    let id: Int
    let url: String
    let thumbnailURL: String
    let succeed: Bool
    let issuedDate: String

    enum CodingKeys: String, CodingKey {
        case id, url, succeed
        case thumbnailURL = "thumbnail_url"
        case issuedDate = "issued_at"
    }
}
