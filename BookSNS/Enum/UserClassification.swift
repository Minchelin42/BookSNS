//
//  UserClassification.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/12.
//

import Foundation

enum UserClassification {
    
    static func isUser(compareID: String) -> Bool {
        return UserDefaultsInfo.userID == compareID
    }
    
    static func isUserLike(likes: [String]) -> Bool {
        return likes.contains { $0 == UserDefaultsInfo.userID }
    }

    static func isUserFollowing(followModel: [FollowModel], id: String) -> Bool {
        for index in 0..<followModel.count {
            let following = followModel[index]
            
            if following.user_id == id {
                return true
            }
        }
        return false
    }
}
