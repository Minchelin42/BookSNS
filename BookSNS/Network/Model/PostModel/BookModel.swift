//
//  BookModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/11.
//

import Foundation

struct BookModel: Decodable {
    let title: String //책 제목
    let priceStandard: Int //정가
    let link: String // 책 판매 URL
    let cover: String // 책 표지 URL
}
