//
//  Extension + String.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/04.
//

import Foundation

extension NumberFormatter {
    static let shared: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension String {
    var makePrice: String {
        guard let price = Int(self) else {
            print("가격 변환 실패")
            return self
        }
        
        guard let formattedPrice = NumberFormatter.shared.string(for: price) else {
            print("가격 변환 실패")
            return self
        }
        
        return formattedPrice
    }
}
