//
//  Extension + String.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/04.
//

import Foundation

extension String {
    
    var makePrice: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let price = Int(self) else {
            print("가격 변환 실패")
            return self
        }
        
        guard let formattedPrice = numberFormatter.string(for: price) else {
            print("가격 변환 실패")
            return self
        }
        
        return formattedPrice
    }

}
