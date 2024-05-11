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
    
    func loadImage(loadURL: URL, defaultImg: String, completionHandler: @escaping (UIImage) -> Void) {
        
        print("이미지 로드 URL: ", loadURL)
        
        let modifier = AnyModifier { request in
            var r = request
            r.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: HTTPHeader.authorization.rawValue)
            r.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
            return r
        }
        
        let loadImage = UIImageView()
        
        loadImage.kf.setImage(with: loadURL, options: [.requestModifier(modifier)], completionHandler: { result in
            switch result {
            case .success(let imageResult):
                print("이미지 로드 성공")
                completionHandler(imageResult.image)
            case .failure(let error):
                print("이미지 로드 실패: \(error)")
                //이미지 변환에 실패했을 때 defaultProfile
                completionHandler(UIImage(systemName: "xmark")!)
            }
        })

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
