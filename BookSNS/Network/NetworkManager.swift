//
//  NetworkManager.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/11.
//

import Foundation
import RxSwift
import Alamofire

struct SignUpModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
}

struct NetworkManager {
    
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
                                print("⭐️⭐️⭐️⭐️ \(code)")
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
