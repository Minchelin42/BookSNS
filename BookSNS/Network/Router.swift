//
//  Router.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/11.
//

import Foundation
import Alamofire

enum Router {
    case signUp(query: SignUpQuery)
}

extension Router: TargetType {

    var baseURL: String {
        return APIKey.baseURL.rawValue
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .signUp:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/users/join"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .signUp:
            return [HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
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
        case .signUp(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        }
    }

}
