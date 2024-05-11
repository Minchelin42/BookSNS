//
//  CommentRouter.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/18.
//

import Foundation
import Alamofire

enum CommentRouter {
    case createComment(id: String, query: CreateCommentQuery)
    case deleteComment(id: String, commentID: String)
}

extension CommentRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .createComment:
            return .post
        case .deleteComment:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .createComment(let id, _):
            return "/posts/\(id)/comments"
        case .deleteComment(let id, let commentID):
            return "/posts/\(id)/comments/\(commentID)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .createComment(let id, let query):
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue]
        case .deleteComment(let id, let commentID):
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
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
        case .createComment(_, let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .deleteComment(let id, let commentID):
            return nil
        }
    }
    
    
}
