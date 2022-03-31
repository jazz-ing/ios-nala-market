//
//  Double+Extension.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/11.
//

import Foundation

extension NumberFormatter {

    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Double {

    func priceFormatted() -> String {
        return NumberFormatter.priceFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
