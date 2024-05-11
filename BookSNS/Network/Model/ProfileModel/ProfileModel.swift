//
//  ProfileModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/11.
//

import Foundation

struct ProfileModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String
    let followers: [FollowModel]
    let following: [FollowModel]
    let posts: [String]
    
    enum CodingKeys: CodingKey {
        case user_id
        case email
        case nick
        case profileImage
        case followers
        case following
        case posts
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user_id = try container.decode(String.self, forKey: .user_id)
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
        self.followers = try container.decode([FollowModel].self, forKey: .followers)
        self.following = try container.decode([FollowModel].self, forKey: .following)
        self.posts = try container.decode([String].self, forKey: .posts)
    }
    
}
