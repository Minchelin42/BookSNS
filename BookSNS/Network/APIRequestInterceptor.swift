//
//  RequestInterceptor.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/02.
//

import Alamofire
import UIKit

class APIRequestInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("으아앙 들어옴")
        var urlRequest = urlRequest
        urlRequest.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: "Authorization")
        
        print("adator 적용 \(urlRequest.headers)")
        completion(.success(urlRequest))
    }
    
    let retryLimit = 3
    let retryDelay: TimeInterval = 1
    
func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        guard let response = request.task?.response as? HTTPURLResponse else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        let statusCode = response.statusCode
        
        if statusCode == 401 {
            completion(.doNotRetry)
            return
        }
        
        getToken { statusCode in
            print("으아아아 상태코드", statusCode)
            if statusCode == 418 {
                print("refreshToken 만료")
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let nav = UINavigationController(rootViewController: SignInViewController())

                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
            }
        }
        
    }
    
    private func getToken(completion: @escaping(Int) -> Void) {
        
        do { let urlRequest: URLRequest = try
            Router.renewToken.asURLRequest()
            print("????")
            
            AF.request(urlRequest)
                .validate(statusCode: 200..<420)
                .responseDecodable(of: TokenModel.self) { response in
                    switch response.result {
                    case .success(let responseModel):
                        print("토큰 갱신 성공",responseModel)
                        print(responseModel)
                        UserDefaults.standard.setValue(responseModel.accessToken, forKey: "accessToken")
                        if let code = response.response?.statusCode {
                            completion(code)
                        }
                    case .failure(let error):
                        if let code = response.response?.statusCode {
                            print("토큰 갱신 실패 \(code)")
                            completion(code)
                        } else {
                            print("토큰 갱신 에러 발생 \(error)")
                        }
                    }
                }
        }catch {
            print("?????")
            print(error)
        }
        
    }
    
}
