//
//  MarketCellType.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/12.
//

import Foundation
import UIKit.UICollectionViewCell

protocol MarketCellType: UICollectionViewCell {
    
    func bind(with viewModel: MarketCollectionViewCellViewModel)
    func setContents()
}
