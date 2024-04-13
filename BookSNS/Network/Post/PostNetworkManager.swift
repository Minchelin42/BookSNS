//
//  PostNetworkManager.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/13.
//

import Foundation
import RxSwift
import Alamofire

struct PostModel: Decodable {
    let post_id: String
    let product_id: String
    let content: String
    let hashTags: [String]
}

struct PostNetworkManager {
    
    static func createPost(query: CreatePostQuery) -> Single<PostModel> {
        return Single<PostModel>.create { single in
            do {
                let urlRequest = try PostRouter.createPost(query: query).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<420)
                    .responseDecodable(of: PostModel.self) { responese in
                        switch responese.result {
                        case .success(let postModel):
                            print("게시글 등록 성공", postModel)
                            single(.success(postModel))
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
    
    
}
