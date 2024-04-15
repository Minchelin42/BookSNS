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
        }
    }
    
    var path: String {
        switch self {
        case .createPost:
            return "/posts"
        case .uploadImage:
            return "/posts/files"
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
        case .createPost(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .uploadImage:
            return nil
        }
    }
    
    
}
