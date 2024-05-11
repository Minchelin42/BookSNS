//
//  FollowModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/11.
//

import Foundation

struct FollowModel: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String
}
