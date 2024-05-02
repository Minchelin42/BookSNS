//
//  MarketRouter.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/02.
//

import Foundation
import Alamofire

struct CreateMarketPostQuery: Encodable {
    var content: String //판매자 한마디
    var content1: String //책 제목
    var content2: String //책 정가
    var content3: String //책 링크
    var content4: String //판매가
    var content5: String //판매여부
    var files: [String] //이미지
    var product_id: String
}


enum MarketRouter {
    case createPost(query: CreateMarketPostQuery)
    case getPost(next: String)
}

extension MarketRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .createPost:
            return .post
        case .getPost:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .createPost:
            return "/posts"
        case .getPost:
            return "/posts"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .createPost:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue]
        case .getPost:
            return [ HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                     HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? ""]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .createPost(let query):
            return nil
        case .getPost(let next):
            return [URLQueryItem(name: "product_id", value: "snapBook_market"), URLQueryItem(name: "limit", value: "15"), URLQueryItem(name: "next", value: next)]
        }
    }
    
    var body: Data? {
        switch self {
        case .createPost(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .getPost(let next):
            return nil
        }
    }
    
}
