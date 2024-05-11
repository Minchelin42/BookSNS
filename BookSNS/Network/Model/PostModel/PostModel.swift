//
//  PostModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/11.
//

import Foundation

struct GetPostModel: Decodable {
    let data: [PostModel]
    let next_cursor: String
}

struct PostModel: Decodable {
    let post_id: String
    let product_id: String
    let content: String
    let content1: String
    let content2: String
    let content3: String
    let content4: String
    let content5: String
    let creator: CreatorModel?
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let hashTags: [String]
    let comments: [CommentModel]
    
    enum CodingKeys: CodingKey {
        case post_id
        case product_id
        case content
        case content1
        case content2
        case content3
        case content4
        case content5
        case creator
        case files
        case likes
        case likes2
        case hashTags
        case comments
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.post_id = try container.decode(String.self, forKey: .post_id)
        self.product_id = try container.decodeIfPresent(String.self, forKey: .product_id) ?? ""
        self.content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
        self.content1 = try container.decodeIfPresent(String.self, forKey: .content1) ?? ""
        self.content2 = try container.decodeIfPresent(String.self, forKey: .content2) ?? ""
        self.content3 = try container.decodeIfPresent(String.self, forKey: .content3) ?? ""
        self.content4 = try container.decodeIfPresent(String.self, forKey: .content4) ?? ""
        self.content5 = try container.decodeIfPresent(String.self, forKey: .content5) ?? ""
        self.creator = try container.decodeIfPresent(CreatorModel.self, forKey: .creator) ?? nil
        self.files = try container.decodeIfPresent([String].self, forKey: .files) ?? []
        self.likes = try container.decodeIfPresent([String].self, forKey: .likes) ?? []
        self.likes2 = try container.decodeIfPresent([String].self, forKey: .likes2) ?? []
        self.hashTags = try container.decodeIfPresent([String].self, forKey: .hashTags) ?? []
        self.comments = try container.decodeIfPresent([CommentModel].self, forKey: .comments) ?? []
    }
}
