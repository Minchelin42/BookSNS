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
    case signIn(query: SignInQuery)
    case emailValidation(query: EmailValidationQuery)
    case withdraw
    case renewToken
}

extension Router: TargetType {

    var baseURL: String {
        return APIKey.baseURL.rawValue
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .signUp, .signIn, .emailValidation:
            return .post
        case .withdraw, .renewToken:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/users/join"
        case .signIn:
            return "/users/login"
        case .emailValidation:
            return "/validation/email"
        case .withdraw:
            return "/users/withdraw"
        case .renewToken:
            return "/auth/refresh"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .signUp, .signIn, .emailValidation:
            return [HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue]
        case .withdraw:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue]
        case .renewToken:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue,
                    HTTPHeader.refresh.rawValue : UserDefaults.standard.string(forKey: "refreshToken") ?? ""]
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
        case .signIn(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .emailValidation(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .withdraw, .renewToken:
            return nil
        }
    }

}
