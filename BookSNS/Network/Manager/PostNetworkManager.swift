//
//  PostNetworkManager.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/13.
//

import Foundation
import RxSwift
import Alamofire

struct PostNetworkManager {
    
    static func like(id: String, query: LikeQuery) -> Single<LikeModel> {
        return Single<LikeModel>.create { single in
            do {
                let urlRequest = try PostRouter.like(id: id, query: query).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<420)
                    .responseDecodable(of: LikeModel.self) { response in
                        switch response.result {
                        case .success(let likeModel):
                            print(likeModel)
                            single(.success(likeModel))
                        case .failure(let error):
                            if let code = response.response?.statusCode {
                                print("에러코드 \(code)")
                            }
                            print(error)
                        }
                    }
                
            } catch {
                print("게시글 스크랩 실패", error)
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    static func getPost() -> Single<GetPostModel> {
        return Single<GetPostModel>.create { single in
            do {
                let urlRequest = try PostRouter.getPost(next: "").asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<420)
                    .responseDecodable(of: GetPostModel.self) { response in
                        switch response.result {
                        case .success(let getPostModel):
                            single(.success(getPostModel))
                        case .failure(let error):
                            if let code = response.response?.statusCode {
                                print("에러코드 \(code)")
                            }
                            print(error)
                        }
                    }
                
            } catch {
                print("게시글 조회 실패", error)
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func uploadImage(query: [Data?]) -> Single<FileModel> {
        return Single<FileModel>.create { single in
            do {
                let urlRequest = try PostRouter.uploadImage.asURLRequest()
                
                AF.upload(multipartFormData: { multipartFormData in
                    for index in 0..<query.count {
                        guard let image = query[index] else { return }
                        multipartFormData.append(image,
                                                 withName: "files",
                                                 fileName: "sesac.png",
                                                 mimeType: "image/png")
                    }
                }, with: urlRequest)
                .validate(statusCode: 200..<410)
                .responseDecodable(of: FileModel.self) { response in
                    switch response.result {
                    case .success(let postModel):
                        print(postModel)
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
