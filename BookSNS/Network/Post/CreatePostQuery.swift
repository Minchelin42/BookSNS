//
//  CreatePostQuery.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/13.
//

import Foundation

struct CreatePostQuery: Encodable {
    let content: String
    let product_id: String
}
