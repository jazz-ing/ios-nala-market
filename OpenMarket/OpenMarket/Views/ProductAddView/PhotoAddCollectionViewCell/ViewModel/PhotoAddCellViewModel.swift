//
//  PhotoAddCellViewModel.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/28.
//

import UIKit.UIImage

final class PhotoAddCellViewModel {

    private(set) var photoImage: Observable<UIImage> = Observable(UIImage())

    func setImage(_ image: UIImage) {
        photoImage.value = image
    }
}
