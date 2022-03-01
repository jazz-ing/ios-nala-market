//
//  ParsingManager.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/12/29.
//

import Foundation

struct ParsingManager {
    
    private let decoder = JSONDecoder()

    func parse<Model: Decodable>(_ data: Data, to model: Model.Type) -> Result<Model, ParsingError> {
        let parsedData = try? decoder.decode(model, from: data)

        guard let modelType = parsedData else {
            return .failure(.decodingFail)
        }
        return .success(modelType)
    }
}
