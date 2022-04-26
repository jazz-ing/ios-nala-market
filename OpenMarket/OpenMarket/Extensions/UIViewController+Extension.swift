//
//  UIViewController+Extension.swift
//  OpenMarket
//
//  Created by 이윤주 on 2022/04/16.
//

import UIKit

extension UIViewController {
    func showAlert(_ title: String) {
        let okActionTitle = "확인"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .default)

        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
