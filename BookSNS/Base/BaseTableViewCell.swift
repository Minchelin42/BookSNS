//
//  BaseTableViewCell.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/16.
//

import UIKit
import Kingfisher

class BaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        
    }
    
    func configureLayout() {
        
    }
    
    func configureView() {
        selectionStyle = .none
    }

}

extension BaseTableViewCell {
    func loadImage(loadURL: URL, defaultImg: String, completionHandler: @escaping (UIImage) -> Void) {
        
        print("이미지 로드 URL: ", loadURL)
        
        let modifier = AnyModifier { request in
            var r = request
            r.setValue(UserDefaultsInfo.accessToken, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
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
}
