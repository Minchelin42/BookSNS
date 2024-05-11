//
//  PayQuery.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/11.
//

import Foundation

struct PayQuery: Encodable {
    var imp_uid: String
    var post_id: String
    var productName: String
    var price: Int
}
