//
//  ParsingManager.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/12/29.
//

import Foundation

struct ParsingManager {
    private let decoder = JSONDecoder()

    init() {
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func parse<Model: Decodable>(data: Data) -> Result<Model, Error> {
        let parsedData = try? decoder.decode(Model.self, from: data)

        guard let modelType = parsedData else {
            fatalError()
        }
        return .success(modelType)
    }
}
