//
//  CreatePostQuery.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/13.
//

import Foundation

struct CreatePostQuery: Encodable {
    var content: String
    var content1: String
    var content2: String
    var content3: String
    var content4: String
    var files: [String]
    var product_id: String
}
