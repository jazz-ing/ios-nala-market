//
//  ParsingError.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/12/29.
//

import Foundation

enum ParsingError: LocalizedError {
    case decodingFail
    
    var errorDescription: String? {
        switch self {
        case .decodingFail:
            return "디코딩에 실패했습니다"
        }
    }
}
