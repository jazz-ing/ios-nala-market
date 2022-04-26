//
//  PlaceholderTextView.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/04/19.
//

import UIKit

class PlaceholderTextView: UITextView {

    enum TextViewType {
        case name
        case stock
        case currency
        case price
        case discountedPrice
        case password
        case description
    }

    // MARK: Property

    private let type: TextViewType

    // MARK: Initializers

    init(type: TextViewType) {
        self.type = type
        super.init(frame: .zero, textContainer: .none)
        setStyles()
        setPlaceHolderText()
    }

    @available(iOS, unavailable, message: "This initializer is not available.")
    required init?(coder: NSCoder) {
        self.type = .name
        super.init(coder: coder)
        setStyles()
        setPlaceHolderText()
    }
}

// MARK: - View configuring methods

extension PlaceholderTextView {

    func setPlaceHolderText() {
        switch type {
        case .name:
            text = Style.PlaceHolderText.name
        case .stock:
            text = Style.PlaceHolderText.stock
        case .currency:
            text = Style.PlaceHolderText.currency
        case .price:
            text = Style.PlaceHolderText.price
        case .discountedPrice:
            text = Style.PlaceHolderText.discountedPrice
        case .password:
            text = Style.PlaceHolderText.password
        case .description:
            text = Style.PlaceHolderText.description
        }
    }

    private func setStyles() {
        font = UIFont.preferredFont(forTextStyle: .body)
        textColor = .systemGray3
        isScrollEnabled = false
        layer.masksToBounds = true
        layer.cornerRadius = Style.cornerRadius
        layer.borderWidth = Style.borderWidth
        layer.borderColor = UIColor.systemGray3.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Namespaces

extension PlaceholderTextView {

    enum Style {

        static let cornerRadius: CGFloat = 10
        static let borderWidth: CGFloat = 1

        enum PlaceHolderText {
            static let name: String = "글 제목"
            static let stock: String = "재고"
            static let currency: String = "통화"
            static let price: String = "가격"
            static let discountedPrice: String = "할인 가격"
            static let password: String = "비밀번호"
            static let description: String = "상품 정보를 입력해주세요."
        }
    }
}
