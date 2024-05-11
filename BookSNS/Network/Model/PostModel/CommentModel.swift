//
//  CommentModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/11.
//

import Foundation

struct CommentModel: Decodable {
    let comment_id: String //댓글 ID
    let content: String //댓글 내용
    let creator: CreatorModel //작성자 정보
}
