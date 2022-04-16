//
//  PhotoAddCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/28.
//

import UIKit

final class PhotoAddCollectionViewCell: UICollectionViewCell {

    static let identifier = "PhotoAddCollectionViewCell"

    private var viewModel: PhotoAddCellViewModel?
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera.viewfinder")
        imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .systemOrange
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }

    @available(iOS, unavailable, message: "This initializer is not available.")
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setConstraints()
    }

    func bind(with viewModel: PhotoAddCellViewModel) {
        self.viewModel = viewModel

        viewModel.photoImage.bind { [weak self] photo in
            self?.photoImageView.image = photo
        }
    }

    func setImage(_ image: UIImage) {
        viewModel?.setImage(image)
    }

    private func setupView() {
        contentView.addSubview(photoImageView)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
