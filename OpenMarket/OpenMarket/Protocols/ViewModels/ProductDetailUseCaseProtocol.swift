//
//  ProductDetailUseCaseProtocol.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/17.
//

import Foundation
import UIKit.UIImage

protocol ProductDetailUseCaseProtocol: AnyObject {

    func fetchProductDetail(
        of id: Int,
        completion: @escaping (Result<Product, Error>) -> Void
    )
    func fetchImage(
        from urlString: String,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) -> Cancellable?
}
