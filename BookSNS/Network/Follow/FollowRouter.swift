//
//  FollowRouter.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/24.
//

import Foundation
import Alamofire


struct SelectFollowModel: Decodable {
    let nick: String
    let opponent_nick: String
    let following_status: Bool
}

enum FollowRouter {
    case follow(id: String)
    case unfollow(id: String)
}

extension FollowRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .follow:
            return .post
        case .unfollow:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .follow(let id):
            return "/follow/\(id)"
        case .unfollow(let id):
            return "/follow/\(id)"
        }
    }

    var header: [String : String] {
        return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue]
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        return nil  
    }

}
