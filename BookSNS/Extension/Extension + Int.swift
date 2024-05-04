//
//  Extension + Int.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/04.
//

import Foundation

extension Int {
    
    func makePrice() -> String {
   
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        guard let formattedPrice = numberFormatter.string(for: self) else {
            return "가격 변환 실패"
        }
        
        return formattedPrice
    }
}
