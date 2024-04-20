//
//  PostRouter.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/13.
//

import Foundation
import Alamofire

enum PostRouter {
    case createPost(query: CreatePostQuery)
    case uploadImage
    case getPost
    case hashTagPost(tag: String)
    case getThisPost(id: String)
    case like(id: String, query: LikeQuery)
}

extension PostRouter: TargetType {

    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .createPost:
            return .post
        case .uploadImage:
            return .post
        case .getPost:
            return .get
        case .hashTagPost:
            return .get
        case .getThisPost:
            return .get
        case .like:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .createPost:
            return "/posts"
        case .uploadImage:
            return "/posts/files"
        case .getPost:
            return "/posts"
        case .hashTagPost:
            return "/posts/hashtags"
        case .getThisPost(let id):
            return "/posts/\(id)"
        case .like(let id, _):
            return "/posts/\(id)/like"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .createPost:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue]
        case .uploadImage:
            return [ HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                     HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                     HTTPHeader.contentType.rawValue: "multipart/form-data" ]
        case .getPost:
            return [ HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                     HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? ""]
        case .hashTagPost:
            return [ HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                     HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? ""]
        case .getThisPost:
            return [ HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                     HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? ""]
        case .like:
            return [ HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                     HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? ""]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .createPost:
            return nil
        case .uploadImage:
            return nil
        case .getPost:
            return [URLQueryItem(name: "product_id", value: "test"), URLQueryItem(name: "limit", value: "10")]
        case .hashTagPost(let tag):
            return [URLQueryItem(name: "hashTag", value: tag)]
        case .getThisPost:
            return nil
        case .like:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .createPost(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .uploadImage:
            return nil
        case .getPost:
            return nil
        case .hashTagPost:
            return nil
        case .getThisPost:
            return nil
        case .like(_, let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        }
    }
    
    
}
