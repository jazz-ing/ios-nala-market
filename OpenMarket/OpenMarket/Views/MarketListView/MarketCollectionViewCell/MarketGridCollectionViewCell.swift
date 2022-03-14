//
//  MarketGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/12.
//

import UIKit

final class MarketGridCollectionViewCell: UICollectionViewCell, MarketCellType {
    
    static let identifier = "MarketGridCollectionViewCell"
    private var viewModel: MarketCollectionViewCellViewModel?
    
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
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
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
        return label
    }()

    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Style.PriceStackView.spacing
        return stackView
    }()

    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .tertiaryLabel
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.accessibilityIdentifier = Style.AccessibilityIdentifier.discountedPriceLabel
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.accessibilityIdentifier = Style.AccessibilityIdentifier.priceLabel
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.accessibilityIdentifier = Style.AccessibilityIdentifier.stockLabel
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setCellBorder()
        setupSubviews()
        setConstraints()
    }

    @available(iOS, unavailable, message: "This initializer is not available.")
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setCellBorder()
        setupSubviews()
        setConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
}

// MARK: - View Configuring MEthod

extension MarketGridCollectionViewCell {

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
        layer.borderColor = .init(gray: 0, alpha: 0)
        layer.cornerRadius = Style.cornerRadius
        accessibilityIdentifier = Style.AccessibilityIdentifier.cell
    }

    private func setupSubviews() {
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
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: Style.Constraint.cellPadding),
            thumbnailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor,
                                                       multiplier: Style.Constraint.thumbnailHeightRatio),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor),
            labelStackView.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor,
                                                      constant: Style.Constraint.cellPadding),
            labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                          constant: Style.Constraint.cellPadding),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                           constant: -Style.Constraint.cellPadding),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                         constant: -Style.Constraint.cellPadding)
        ])
    }
}

// MARK: - Binding Method

extension MarketGridCollectionViewCell {

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

extension MarketGridCollectionViewCell {

    private enum Style {

        static let borderWidth: CGFloat = 0.5
        static let cornerRadius: CGFloat = 10

        enum ThumbnailImageView {
            static let cornerRadius: CGFloat = 10
        }

        enum LabelStackView {
            static let spacing: CGFloat = 8
        }
        
        enum PriceStackView {
            static let spacing: CGFloat = .zero
        }
        
        enum AccessibilityIdentifier {
            static let cell: String = "marketGridCell"
            static let thumbnailImageView: String = "thumbnail"
            static let nameLabel: String = "productName"
            static let stockLabel: String = "stock"
            static let discountedPriceLabel: String = "discountedPrice"
            static let priceLabel: String = "price"
        }

        enum Constraint {
            static let cellPadding: CGFloat = 20
            static let thumbnailHeightRatio: CGFloat = 0.4
        }
    }
}

