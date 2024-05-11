//
//  NetworkManager.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/11.
//

import Foundation
import RxSwift
import Alamofire

struct NetworkManager {
    
    static func uploadProfile(query: ProfileQuery) -> Single<ProfileModel> {
        return Single<ProfileModel>.create { single in
            do {
                let urlRequest = try ProfileRouter.editProfile(query: query).asURLRequest()
                
                AF.upload(multipartFormData: { multipartFormData in
            
                    multipartFormData.append(query.profile,
                                                 withName: "profile",
                                                 fileName: "sesac.png",
                                                 mimeType: "image/png")
                    if let stringData = query.nick.data(using: .utf8) {
                           multipartFormData.append(stringData, withName: "nick")
                       }
                    
                }, with: urlRequest)
                .validate(statusCode: 200..<410)
                .responseDecodable(of: ProfileModel.self) { response in
                    switch response.result {
                    case .success(let responseModel):
                        print(responseModel)
                        single(.success(responseModel))
                    case .failure(let error):
                        print(error)
                    }
                }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    static func DeleteAPI (router: TargetType, closure: @escaping (Bool) -> Void) {
        do {
            let urlRequest = try router.asURLRequest()
            
            AF.request(urlRequest)
                .validate(statusCode: 200..<420)
                .response { response in
                    switch response.result {
                    case .success:
                        print("삭제 성공")
                        closure(true)
                    case .failure(let error):
                        if let code = response.response?.statusCode {
                            print("삭제 실패 \(code)")
                            closure(false)
                        } else {
                            print("삭제 통신 에러 발생 \(error)")
                        }
                    }
                }
        } catch {
            print(error)
        }
        
    }
    
    static func APIcall<T: Decodable>(type: T.Type, router: TargetType) -> Single<T> {
        return Single<T>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                AF.request(urlRequest, interceptor: APIRequestInterceptor())
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
