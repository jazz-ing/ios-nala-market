//
//  Observable.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/03/04.
//

import Foundation

final class Observable<T> {

    typealias Listener = (T) -> Void
    var listener: Listener?

    var value: T {
      didSet {
        listener?(value)
      }
    }

    init(_ value: T) {
      self.value = value
    }

    func bind(listener: Listener?) {
      self.listener = listener
      listener?(value)
    }
}
