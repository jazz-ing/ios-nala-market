//
//  String+Extension.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/11.
//

import UIKit

extension String {

    func strikeThrough() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: .zero, length: attributedString.length)
        )
        return attributedString
    }
}
