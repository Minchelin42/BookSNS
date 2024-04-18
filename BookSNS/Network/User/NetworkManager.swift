//
//  NetworkManager.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/11.
//

import Foundation
import RxSwift
import Alamofire

struct MessageModel: Decodable {
    let message: String
}

struct SignUpModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
}

struct SignInModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: CodingKey {
        case user_id
        case email
        case nick
        case profileImage
        case accessToken
        case refreshToken
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user_id = try container.decode(String.self, forKey: .user_id)
        self.email = try container.decode(String.self, forKey: .email)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? "" //profileImage가 없을 경우 ""로 받아옴
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
    }
}

struct NetworkManager {
    
    static func APIcall<T: Decodable>(type: T.Type, router: TargetType) -> Single<T> {
        return Single<T>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<420)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let responseModel):
                            print("제네릭 통신 성공",responseModel)
                            single(.success(responseModel))
                        case .failure(let error):
                            if let code = response.response?.statusCode {
                                print("제네릭 통신 실패 \(code)")
                                single(.failure(error))
                            } else {
                                print("제네릭 통신 에러 발생 \(error)")
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
}
