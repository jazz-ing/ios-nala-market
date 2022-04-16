//
//  ProductAddViewController.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/28.
//

import UIKit
import PhotosUI

final class ProductAddViewController: UIViewController {

    private var viewModel: ProductAddViewModel?

    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = Style.PhotoCollectionView.imageSectionInsets
        layout.itemSize = Style.PhotoCollectionView.imageItemSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoAddCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoAddCollectionViewCell.identifier)
        return collectionView
    }()

    @available(iOS 14, *)
    private lazy var multipleImagePicker: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = Style.ImagePicker.imageSelectLimit
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        return picker
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }()

    private let nameTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = false
        textView.text = Style.PlaceHolderText.name
        textView.textColor = .systemGray3
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = Style.TextView.cornerRadius
        textView.layer.borderWidth = Style.TextView.borderWidth
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let stockTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = false
        textView.text = Style.PlaceHolderText.stock
        textView.textColor = .systemGray3
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = Style.TextView.cornerRadius
        textView.layer.borderWidth = Style.TextView.borderWidth
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Style.spacing / 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let currencyPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()

    private let currencyTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = Style.PlaceHolderText.currency
        textView.textColor = .systemGray3
        textView.setContentHuggingPriority(.required, for: .horizontal)
        textView.setContentCompressionResistancePriority(.required, for: .horizontal)
        textView.isScrollEnabled = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = Style.TextView.cornerRadius
        textView.layer.borderWidth = Style.TextView.borderWidth
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        return textView
    }()

    private let priceTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = false
        textView.text = Style.PlaceHolderText.price
        textView.textColor = .systemGray3
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = Style.TextView.cornerRadius
        textView.layer.borderWidth = Style.TextView.borderWidth
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        return textView
    }()

    private let discountedTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = false
        textView.text = Style.PlaceHolderText.discountedPrice
        textView.textColor = .systemGray3
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = Style.TextView.cornerRadius
        textView.layer.borderWidth = Style.TextView.borderWidth
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        return textView
    }()

    private let passwordTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = false
        textView.text = Style.PlaceHolderText.password
        textView.textColor = .systemGray3
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = Style.TextView.cornerRadius
        textView.layer.borderWidth = Style.TextView.borderWidth
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = Style.PlaceHolderText.description
        textView.textColor = .systemGray3
        textView.isScrollEnabled = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = Style.TextView.cornerRadius
        textView.layer.borderWidth = Style.TextView.borderWidth
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupPickerView()
        setupNavigationBar()
        setupToolbar()
        setDelegates()
        setConstraints()
    }
}

// MARK: - Binding Method

extension ProductAddViewController {
    
    func bind(with viewModel: ProductAddViewModel) {
        self.viewModel = viewModel
        
        viewModel.state.bind { [weak self] state in
            switch state {
            case .appendImage(let index):
                let indexPath = IndexPath(item: index, section: .zero)
                self?.photoCollectionView.insertItems(at: [indexPath])
            case .add(let product):
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.showAlert(Style.Alert.productAddSucceedAlertTitle)
                    self?.navigationController?.popViewController(animated: false)
                }
            default:
                break
            }
        }
    }
}

// MARK: - View Configuring Method

extension ProductAddViewController {

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(contentScrollView)
        view.addSubview(activityIndicator)
        contentScrollView.addSubview(contentView)
        contentView.addSubview(photoCollectionView)
        contentView.addSubview(nameTextView)
        contentView.addSubview(stockTextView)
        contentView.addSubview(priceStackView)
        contentView.addSubview(passwordTextView)
        contentView.addSubview(descriptionTextView)
        priceStackView.addArrangedSubview(currencyTextView)
        priceStackView.addArrangedSubview(priceTextView)
        priceStackView.addArrangedSubview(discountedTextView)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.frameLayoutGuide.widthAnchor),

            photoCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoCollectionView.heightAnchor.constraint(equalTo: photoCollectionView.widthAnchor, multiplier: Style.PhotoCollectionView.heightRatio),

            nameTextView.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: Style.spacing),
            nameTextView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            nameTextView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),

            stockTextView.topAnchor.constraint(equalTo: nameTextView.bottomAnchor, constant: Style.spacing),
            stockTextView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            stockTextView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),

            priceStackView.topAnchor.constraint(equalTo: stockTextView.bottomAnchor, constant: Style.spacing),
            priceStackView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            priceStackView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),

            passwordTextView.topAnchor.constraint(equalTo: priceStackView.bottomAnchor, constant: Style.spacing),
            passwordTextView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            passwordTextView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),

            descriptionTextView.topAnchor.constraint(equalTo: passwordTextView.bottomAnchor, constant: Style.spacing),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.readableContentGuide.bottomAnchor)
        ])
    }
    
    func setDelegates() {
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        if #available(iOS 14, *) {
            multipleImagePicker.delegate = self
        } else {
            imagePicker.delegate = self
        }
        currencyPickerView.dataSource = self
        currencyPickerView.delegate = self
        nameTextView.delegate = self
        stockTextView.delegate = self
        priceTextView.delegate = self
        discountedTextView.delegate = self
        passwordTextView.delegate = self
        descriptionTextView.delegate = self
    }

    private func setupNavigationBar() {
        navigationItem.title = Style.NavigationBar.title
        let registerButton = UIBarButtonItem(title: Style.NavigationBar.doneButtonTitle,
                                             style: .plain,
                                             target: self,
                                             action: #selector(registerButtonTapped))
        navigationItem.rightBarButtonItem = registerButton
    }
    
    @objc func registerButtonTapped() {
        activityIndicator.startAnimating()
        guard let newProduct = viewModel?.createNewProduct() else {
            showAlert(Style.Alert.requiredContentsNotFilledAlertTitle)
            return
        }
        viewModel?.addNewProduct()
    }
    
    private func setupPickerView() {
        currencyTextView.inputView = currencyPickerView
    }
    
    private func setupToolbar() {
        let toolBar = UIToolbar(frame: Style.CurrencyPickerView.toolBarFrame)
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: Style.CurrencyPickerView.doneButtonTitle,
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.donePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        let cancelButton = UIBarButtonItem(title: Style.CurrencyPickerView.cancelButtonTitle,
                                           style: .plain,
                                           target: self,
                                           action: #selector(self.cancelPicker))
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        currencyTextView.inputAccessoryView = toolBar
    }

    @objc func donePicker() {
        let row = currencyPickerView.selectedRow(inComponent: Style.CurrencyPickerView.selectedIndex)
        currencyPickerView.selectRow(row, inComponent: Style.CurrencyPickerView.selectedIndex,
                                     animated: false)
        currencyTextView.textColor = .black
        currencyTextView.text = viewModel?.currencyPickerValues[row]
        currencyTextView.resignFirstResponder()
    }

    @objc func cancelPicker() {
        currencyTextView.text = Style.PlaceHolderText.currency
        currencyTextView.textColor = .systemGray3
        currencyTextView.resignFirstResponder()
    }
}

// MARK: - PhotoCollectionView Datasource

extension ProductAddViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let numberOfImages = viewModel?.images.count else { return .zero}
        return numberOfImages + Style.PhotoCollectionView.indexOffset
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoAddCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoAddCollectionViewCell else { return UICollectionViewCell() }
        
        switch indexPath.item {
        case .zero:
            return cell
        default:
            guard let photoImage = viewModel?.images[indexPath.item - Style.PhotoCollectionView.indexOffset] else { return UICollectionViewCell() }
            let photoCellViewModel = PhotoAddCellViewModel()
            cell.bind(with: photoCellViewModel)
            cell.setImage(photoImage)
            
            return cell
        }
    }
}

// MARK: - PhotoCollectionView Delegate

extension ProductAddViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if #available(iOS 14, *) {
            self.present(multipleImagePicker, animated: true, completion: nil)
        } else {
            self.present(self.imagePicker, animated: true)
        }
    }
}

// MARK: - MultipleImagePicker Delegate

extension ProductAddViewController: PHPickerViewControllerDelegate {
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        results.forEach { result in
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let image = image as? UIImage else { return }
                    DispatchQueue.main.async {
                        self?.viewModel?.append(image: image)
                    }
                }
            }
        }
    }
}

// MARK: - ImagePicker Delegate

extension ProductAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        DispatchQueue.main.async {
            self.viewModel?.append(image: newImage ?? UIImage())
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CurrencyPickerView Datasource, Delegate

extension ProductAddViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Style.CurrencyPickerView.numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel?.currencyPickerValues.count ?? .zero
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel?.currencyPickerValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currencyTextView.text = viewModel?.currencyPickerValues[row]
        viewModel?.fillProductCurrency(viewModel?.currencyPickerValues[row])
    }
}

// MARK: - TextView Delegate

extension ProductAddViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == currencyTextView {
            textView.textColor = .black
        } else if textView.textColor == .systemGray3 {
            textView.text = Style.TextView.emptyText
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel?.fillProduct(name: nameTextView.text,
                               descriptions: descriptionTextView.text,
                               price: priceTextView.text,
                               discountedPrice: discountedTextView.text,
                               stock: stockTextView.text,
                               password: passwordTextView.text)
    }
}

// MARK: - NameSpace

extension ProductAddViewController {

    private enum Style {

        static let spacing: CGFloat = 10

        enum NavigationBar {
            static let title: String = "상품 등록"
            static let doneButtonTitle: String = "완료"
        }

        enum PhotoCollectionView {
            static let imageSectionInsets: UIEdgeInsets = UIEdgeInsets(top: 20,
                                                                       left: 10,
                                                                       bottom: 10,
                                                                       right: 10)
            static let imageItemSize: CGSize = CGSize(width: 80, height: 80)
            static let heightRatio: CGFloat = 0.3
            static let indexOffset: Int = 1
        }
        
        enum ImagePicker {
            static let imageSelectLimit: Int = 5
        }

        enum TextView {
            static let emptyText: String = ""
            static let cornerRadius: CGFloat = 10
            static let borderWidth: CGFloat = 1
        }
        
        enum CurrencyPickerView {
            static let numberOfComponents: Int = 1
            static let selectedIndex: Int = 0
            static let toolBarFrame: CGRect = CGRect(x: 0, y: 0, width: 375, height: 30)
            static let doneButtonTitle: String = "완료"
            static let cancelButtonTitle: String = "취소"
        }

        enum PlaceHolderText {
            static let name: String = "글 제목"
            static let stock: String = "재고"
            static let currency: String = "통화"
            static let price: String = "가격"
            static let discountedPrice: String = "할인 가격"
            static let password: String = "비밀번호"
            static let description: String = "상품 정보를 입력해주세요."
        }

        enum Alert {
            static let productAddSucceedAlertTitle: String = "상품 등록이 완료됐습니다."
            static let requiredContentsNotFilledAlertTitle = "필수항목을 모두 작성해주세요."
        }
    }
}


