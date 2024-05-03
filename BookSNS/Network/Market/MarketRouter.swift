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

struct PayList: Decodable {
    var data: [PayValidationModel]
}

struct PayValidationModel: Decodable{
    var payment_id: String
    var buyer_id: String
    var post_id: String
    var merchant_uid: String
    var productName: String
    var price: Int
    var paidAt: String
}

struct PayQuery: Encodable {
    var imp_uid: String
    var post_id: String
    var productName: String
    var price: Int
}

enum MarketRouter {
    case createPost(query: CreateMarketPostQuery)
    case getPost(next: String)
    case payValidation(query: PayQuery)
    case getShoppingList
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
        case .payValidation:
            return .post
        case .getShoppingList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .createPost:
            return "/posts"
        case .getPost:
            return "/posts"
        case .payValidation:
            return "/payments/validation"
        case .getShoppingList:
            return "/payments/me"
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
        case .payValidation:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue]
        case .getShoppingList:
            return [HTTPHeader.authorization.rawValue: UserDefaults.standard.string(forKey: "accessToken") ?? "",
                    HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getPost(let next):
            return [URLQueryItem(name: "product_id", value: "snapBook_market"), URLQueryItem(name: "limit", value: "15"), URLQueryItem(name: "next", value: next)]
        case .createPost, .payValidation, .getShoppingList:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .createPost(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .getPost:
            return nil
        case .payValidation(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .getShoppingList:
            return nil
        }
    }
    
}
