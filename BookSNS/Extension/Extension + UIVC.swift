//
//  Extension + UIViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/04.
//

import UIKit
import Kingfisher
import Toast

extension UIViewController {
    func customBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = Color.mainColor
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func customTitle() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "Logo")
        imageView.image = image
        self.navigationItem.titleView = imageView
    }

    func makeToast(_ message: String) {
        var style = ToastStyle()

        style.messageColor = .white
        style.backgroundColor = Color.mainColor!
        style.messageFont = .systemFont(ofSize: 13, weight: .semibold)

        self.view.makeToast(message, duration: 0.8, position: .bottom, style: style)
    }
    
    func oneButtonAlert(_ title: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let button = UIAlertAction(title: "확인", style: .default) { action in
            completionHandler()
        }
        alert.addAction(button)
        
        self.present(alert, animated: true)
    }

}
