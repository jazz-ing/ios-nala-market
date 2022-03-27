//
//  DecodingManager.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/12/29.
//

import Foundation

enum CodableError: LocalizedError {

    case decodingFail
    case encodingFail

    var errorDescription: String? {
        switch self {
        case .decodingFail:
            return "디코딩에 실패했습니다."
        case .encodingFail:
            return "인코딩에 실패했습니다."
        }
    }
}

struct DecodingManager {

    private let decoder = JSONDecoder()

    func decode<Model: Decodable>(_ data: Data, to model: Model.Type) -> Result<Model, CodableError> {
        guard let decodedData = try? decoder.decode(model, from: data) else {
            return .failure(.decodingFail)
        }
        return .success(decodedData)
    }
}
