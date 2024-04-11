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
    
    static func emailValidation(query: EmailValidationQuery) -> Single<MessageModel> {
        return Single<MessageModel>.create { single in
            do {
                let urlRequest = try Router.emailValidation(query: query).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<410)
                    .responseDecodable(of: MessageModel.self) { response in
                        switch response.result {
                        case .success(let messageModel):
                            print("이메일 중복 확인 성공", messageModel)
                            single(.success(messageModel))
                        case .failure(let error):
                            if let code = response.response?.statusCode {
                                print("이메일 중복 확인 실패 \(code)")
                                single(.failure(error))
                            } else {
                                print("이메일 중복 확인 실패 \(error)")
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func signIn(query: SignInQuery) -> Single<SignInModel> {
        return Single<SignInModel>.create { single in
            do {
                let urlRequest = try Router.signIn(query: query).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<410)
                    .responseDecodable(of: SignInModel.self) { response in
                        switch response.result {
                        case .success(let signInModel):
                            print(signInModel)
                            single(.success(signInModel))
                        case .failure(let error):
                            if let code = response.response?.statusCode {
                                print("로그인 실패 \(code)")
                                single(.failure(error))
                            } else {
                                print("error 발생 \(error)")
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func signUp(query: SignUpQuery) -> Single<SignUpModel> {
        return Single<SignUpModel>.create { single in
            do {
                let urlRequest = try Router.signUp(query: query).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<410)
                    .responseDecodable(of: SignUpModel.self) { response in
                        switch response.result {
                        case .success(let signUpModel):
                            print(signUpModel)
                            single(.success(signUpModel))
                        case .failure(let error):
                            if let code = response.response?.statusCode {
                                print("회원가입 실패 \(code)")
                                single(.failure(error))
                            } else {
                                print("error 발생 \(error)")
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
