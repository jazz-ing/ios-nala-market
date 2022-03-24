//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/17.
//

import UIKit

final class ProductDetailViewController: UIViewController {

    private var viewModel: ProductDetailViewModel?

    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.accessibilityIdentifier = Style.AccessibilityIdentifier.contentScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.accessibilityIdentifier = Style.AccessibilityIdentifier.contentView
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.accessibilityIdentifier = Style.AccessibilityIdentifier.imageScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private var imageViews: [UIImageView] = []

    private let imageScrollViewPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .systemOrange
        pageControl.accessibilityIdentifier = Style.AccessibilityIdentifier.imageScrollViewPageControl
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    private let textContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Style.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let upperTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.distribution = .fill
        return stackView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = .zero
        label.accessibilityIdentifier = Style.AccessibilityIdentifier.nameLabel
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.accessibilityIdentifier = Style.AccessibilityIdentifier.stockLabel
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let lowerTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = .tertiaryLabel
        label.accessibilityIdentifier = Style.AccessibilityIdentifier.discountedPriceLabel
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Style.priceFontSize)
        label.accessibilityIdentifier = Style.AccessibilityIdentifier.priceLabel
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = false
        textView.accessibilityIdentifier = Style.AccessibilityIdentifier.descriptionTextView
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setupNavigationBar()
        setDelegate()
    }
}

// MARK: - View Configuring Method

extension ProductDetailViewController {
    
    private func addProductImage(_ image: UIImage, to index: Int) {
        let imageView = UIImageView()
        let xPosition: CGFloat = view.frame.width * CGFloat(index)
        imageView.frame = .init(x: xPosition,
                                y: .zero,
                                width: imageScrollView.bounds.width,
                                height: imageScrollView.bounds.height)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageScrollView.insertSubview(imageView, belowSubview: imageScrollViewPageControl)
        imageScrollView.contentSize.width = imageView.frame.width * CGFloat(index + Style.indexOffset)
        imageViews.append(imageView)
    }

    private func setupViews() {
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(contentView)
        contentView.addSubview(imageScrollView)
        contentView.addSubview(textContentStackView)
        contentView.addSubview(descriptionTextView)
        imageScrollView.addSubview(imageScrollViewPageControl)
        textContentStackView.addArrangedSubview(upperTextStackView)
        textContentStackView.addArrangedSubview(lowerTextStackView)
        upperTextStackView.addArrangedSubview(nameLabel)
        upperTextStackView.addArrangedSubview(stockLabel)
        lowerTextStackView.addArrangedSubview(discountedPriceLabel)
        lowerTextStackView.addArrangedSubview(priceLabel)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.frameLayoutGuide.widthAnchor),

            imageScrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

            imageScrollViewPageControl.centerXAnchor.constraint(equalTo: imageScrollView.frameLayoutGuide.centerXAnchor),
            imageScrollViewPageControl.bottomAnchor.constraint(equalTo: imageScrollView.frameLayoutGuide.bottomAnchor, constant: -Style.padding),

            textContentStackView.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: Style.padding),
            textContentStackView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            textContentStackView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),

            descriptionTextView.topAnchor.constraint(equalTo: textContentStackView.bottomAnchor, constant: Style.padding),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.readableContentGuide.bottomAnchor)
        ])
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.topItem?.title = Style.emptyText
    }

    private func setPageNumber(to numberOfImages: Int) {
        imageScrollViewPageControl.numberOfPages = numberOfImages
    }

    private func setCurrentPage(to currentPage: Int) {
        imageScrollViewPageControl.currentPage = currentPage
    }
}

// MARK: - NameSpaces

enum Style {

    static let indexOffset: Int = 1
    static let stackViewSpacing: CGFloat = 5
    static let padding: CGFloat = 10
    static let emptyText: String = ""
    static let priceFontSize: CGFloat = UIFont.preferredFont(forTextStyle: .title2).pointSize

    enum AccessibilityIdentifier {
        static let contentScrollView = "contentScrollView"
        static let contentView = "content"
        static let imageScrollView = "imagePagingScrollView"
        static let imageScrollViewPageControl = "imagePageControl"
        static let nameLabel = "productName"
        static let stockLabel = "stock"
        static let discountedPriceLabel = "discountedPrice"
        static let priceLabel = "price"
        static let descriptionTextView = "descriptions"
    }
}
