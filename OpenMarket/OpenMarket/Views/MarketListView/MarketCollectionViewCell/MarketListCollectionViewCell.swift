//
//  MarketListCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/11.
//

import UIKit

class MarketListCollectionViewCell: UICollectionViewCell, MarketCellType {

    // MARK: Properties

    static let identifier = Text.cellIdentifier
    private var viewModel: MarketCollectionViewCellViewModel?

    // MARK: Views

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Style.ThumbnailImageView.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.accessibilityIdentifier = Style.AccessibilityIdentifier.thumbnailImageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = Style.LabelStackView.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.textAlignment = .center
        label.accessibilityIdentifier = Style.AccessibilityIdentifier.nameLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = Style.PriceStackView.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .tertiaryLabel
        label.accessibilityIdentifier = Style.AccessibilityIdentifier.discountedLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.accessibilityIdentifier = Style.AccessibilityIdentifier.priceLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        label.accessibilityIdentifier = Style.AccessibilityIdentifier.stockLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setCellBorder()
        setUpSubviews()
        setConstraints()
    }

    @available(*, unavailable, message: "This initializer is not available.")
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setCellBorder()
        setUpSubviews()
        setConstraints()
    }

    // MARK: Override

    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
}

// MARK: - View configuring method

extension MarketListCollectionViewCell {

    private func reset() {
        viewModel?.cancelThumbnailRequest()
        thumbnailImageView.image = nil
        nameLabel.text = nil
        stockLabel.text = nil
        discountedPriceLabel.attributedText = nil
        priceLabel.text = nil
    }

    private func setCellBorder() {
        layer.borderWidth = Style.borderWidth
        layer.borderColor = Style.borderColor
        layer.cornerRadius = Style.cornerRadius
        accessibilityIdentifier = Style.AccessibilityIdentifier.cell
    }

    private func setUpSubviews() {
        priceStackView.addArrangedSubview(discountedPriceLabel)
        priceStackView.addArrangedSubview(priceLabel)

        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(priceStackView)
        labelStackView.addArrangedSubview(stockLabel)

        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(labelStackView)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Style.Constraint.cellPadding
            ),
            thumbnailImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            thumbnailImageView.heightAnchor.constraint(
                equalTo: contentView.heightAnchor,
                multiplier: Style.Constraint.contentHeightRatio
            ),
            thumbnailImageView.widthAnchor.constraint(
                equalTo: contentView.widthAnchor,
                multiplier: Style.Constraint.imageWidthRatio
            ),
            labelStackView.topAnchor.constraint(
                equalTo: thumbnailImageView.topAnchor
            ),
            labelStackView.leadingAnchor.constraint(
                equalTo: thumbnailImageView.trailingAnchor,
                constant: Style.Constraint.contentsSpacing
            ),
            labelStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Style.Constraint.cellPadding
            ),
            labelStackView.heightAnchor.constraint(
                equalTo: thumbnailImageView.heightAnchor
            )
        ])
    }
}

// MARK: - Data binding method

extension MarketListCollectionViewCell {

    func bind(with viewModel: MarketCollectionViewCellViewModel) {
        self.viewModel = viewModel

        viewModel.state.bind { [weak self] state in
            switch state {
            case .update(let productData):
                DispatchQueue.main.async {
                    self?.thumbnailImageView.image = productData.thumbnail
                    self?.nameLabel.text = productData.name
                    self?.stockLabel.text = productData.stock
                    self?.discountedPriceLabel.isHidden = !productData.hasDiscountedPrice
                    self?.discountedPriceLabel.attributedText = productData.discountedPrice
                    self?.priceLabel.text = productData.price
                    self?.stockLabel.textColor = productData.isOutOfStock ?
                        UIColor.systemOrange
                        : .secondaryLabel
                }
            case .error(_):
                self?.thumbnailImageView.image = nil
            default:
                break
            }
        }
    }

    func setContents() {
        viewModel?.setContents()
    }
}

// MARK: - Namespaces

extension MarketListCollectionViewCell {

    enum Style {

        static let borderWidth: CGFloat = 0.2
        static let borderColor: CGColor = .init(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2)
        static let cornerRadius: CGFloat = 0.5

        enum ThumbnailImageView {
            static let cornerRadius: CGFloat = 10
        }

        enum LabelStackView {
            static let spacing: CGFloat = 8
        }

        enum PriceStackView {
            static let spacing: CGFloat = 6
        }

        enum AccessibilityIdentifier {
            static let cell = "MarketListCell"
            static let thumbnailImageView = "thumbnail"
            static let nameLabel = "productName"
            static let discountedLabel = "discountedPrice"
            static let priceLabel = "price"
            static let stockLabel = "stock"
        }

        enum Constraint {
            static let cellPadding: CGFloat = 8
            static let contentsSpacing: CGFloat = 12
            static let contentHeightRatio: CGFloat = 0.85
            static let imageWidthRatio: CGFloat = 0.3
        }
    }

    enum Text {
        static let cellIdentifier = "MarketListCollectionViewCell"
    }
}
