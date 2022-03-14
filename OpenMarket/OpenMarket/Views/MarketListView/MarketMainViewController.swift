//
//  MarketMainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MarketMainViewController: UIViewController {

    private enum CellType {
        case grid
        case list
    }

    private var cellType: CellType = .list
    private let viewModel = MarketListViewModel()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(MarketGridCollectionViewCell.self,
                                forCellWithReuseIdentifier: MarketGridCollectionViewCell.identifier)
        collectionView.register(MarketListCollectionViewCell.self,
                                forCellWithReuseIdentifier: MarketListCollectionViewCell.identifier)
        collectionView.accessibilityIdentifier = Style.AccessibilityIdentifier.collectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setDelegates()
        bindWithViewModel()
        viewModel.update()
    }
}

// MARK: - View Configuring Method

extension MarketMainViewController {

    private func bindWithViewModel() {
        viewModel.state.bind { [weak self] state in
            switch state {
            case .populated(let indexPaths):
                DispatchQueue.main.async {
                    self?.collectionView.insertItems(at: indexPaths)
                }
            case .empty:
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            default:
                break
            }
        }
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - CollectionView DataSource

extension MarketMainViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MarketCellType
        
        switch cellType {
        case .grid:
            guard let gridCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MarketGridCollectionViewCell.identifier,
                for: indexPath
            ) as? MarketGridCollectionViewCell else { return MarketGridCollectionViewCell() }
            cell = gridCell
        case .list:
            guard let listCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MarketListCollectionViewCell.identifier,
                for: indexPath
            ) as? MarketListCollectionViewCell else { return MarketListCollectionViewCell() }
            cell = listCell
        }

        let product = viewModel.products[indexPath.row]
        let cellViewModel = MarketCollectionViewCellViewModel(product: product)

        cell.bind(with: cellViewModel)
        cell.setContents()

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MarketMainViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch cellType {
        case .grid:
            let paddingSpace = Style.Cell.gridSectionInsets.left * (Style.Cell.gridItemsPerRow + 1)
            let width = (collectionView.bounds.width - paddingSpace) / Style.Cell.gridItemsPerRow
            let height = (collectionView.bounds.height) / Style.Cell.gridItemsPerHeight
            return CGSize(width: width, height: height)
        case .list:
            let width = collectionView.bounds.width
            let height = collectionView.bounds.height / Style.Cell.listItemPerHeight
            return CGSize(width: width, height: height)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Style.Cell.gridSectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Style.Cell.gridSectionInsets.left
    }
}

// MARK: - Namespaces

extension MarketMainViewController {

    private enum Style {

        enum Cell {
            static let gridItemsPerRow: CGFloat = 2
            static let gridItemsPerHeight: CGFloat = 2.3
            static let gridItemSpacing: CGFloat = 10
            static let gridSectionInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            static let listItemPerHeight: CGFloat = 5
        }

        enum AccessibilityIdentifier {
            static let collectionView: String = "marketProductList"
        }
    }
}
