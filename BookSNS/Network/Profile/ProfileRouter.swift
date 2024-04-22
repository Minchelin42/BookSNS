//
//  ProfileRouter.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/18.
//

import Foundation
import Alamofire

struct ProfileQuery: Encodable {
    var nick: String
    var profile: Data
}

struct ProfileModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String
    let followers: [String]
    let following: [String]
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
        self.followers = try container.decode([String].self, forKey: .followers)
        self.following = try container.decode([String].self, forKey: .following)
        self.posts = try container.decode([String].self, forKey: .posts)
    }
    
}

enum ProfileRouter {
    case myProfile
    case otherProfile(id: String)
    case getScraplist
    case editProfile(query: ProfileQuery)
}

extension ProfileRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .myProfile:
            return .get
        case .otherProfile:
            return .get
        case .getScraplist:
            return .get
        case .editProfile:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .myProfile:
            return "/users/me/profile"
        case .otherProfile(let id):
            return "/users/\(id)/profile"
        case .getScraplist:
            return "/posts/likes/me"
        case .editProfile:
            return "/users/me/profile"
        }
    }

    var header: [String : String] {
        
        switch self {
        case .myProfile:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue]
        case .otherProfile:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue]
        case .getScraplist:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue]
        case .editProfile:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.contentType.rawValue: "multipart/form-data",
                    HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue]
        }
        
        
        
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .myProfile:
            return nil
        case .otherProfile:
            return nil
        case .getScraplist:
            return nil
        case .editProfile:
            return nil
        }
    }

}
