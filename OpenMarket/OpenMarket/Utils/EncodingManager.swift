//
//  EncodingManager.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/27.
//

import Foundation

struct EncodingManager {

    private let encoder = JSONEncoder()

    func encode<Model: Encodable>(_ model: Model) -> Result<Data, CodableError> {
        guard let encodedData = try? encoder.encode(model) else {
            return .failure(.encodingFail)
        }
        return .success(encodedData)
    }
}
