//
//  ThumbnailUseCase.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/08.
//

import Foundation
import UIKit.UIImage

enum ThumbnailUseCaseError: LocalizedError {

    case invalidImageData
}

protocol ThumbnailUseCaseProtocol {

    func fetchThumbnail(
        from urlString: String,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) -> Cancellable?
}

final class ThumbnailUseCase: ThumbnailUseCaseProtocol {

    // MARK: Properties

    private let networkManager: NetworkManageable
    private var imageCache = NSCache<NSString, UIImage>()

    // MARK: Initializer

    init(networkManager: NetworkManageable = NetworkManager()) {
        self.networkManager = networkManager
    }

    // MARK: Thumbnail fetching method

    func fetchThumbnail(
        from urlString: String,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) -> Cancellable? {
        let cacheKey = NSString(string: urlString)
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            completion(.success(cachedImage))
            return nil
        }

        let task = networkManager.request(to: urlString) { [weak self] result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(ThumbnailUseCaseError.invalidImageData))
                    return
                }
                self?.imageCache.setObject(image, forKey: cacheKey)
                completion(.success(image))
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
        task?.resume()
        return task
    }
}
