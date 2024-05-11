//
//  SelectFollowModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/11.
//

import Foundation

struct SelectFollowModel: Decodable {
    let nick: String
    let opponent_nick: String
    let following_status: Bool
}
