//
//  CellType.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/12.
//

import Foundation

protocol CellType {
    static var identifier: String { get }
}

extension CellType {
    static var identifier: String {
        return String(describing: self)
    }
}

