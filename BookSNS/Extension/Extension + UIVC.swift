//
//  Extension + UIViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/04.
//

import UIKit

extension UIViewController {
    func customBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = Color.mainColor
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}
