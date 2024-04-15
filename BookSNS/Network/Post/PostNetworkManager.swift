//
//  PostNetworkManager.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/13.
//

import Foundation
import RxSwift
import Alamofire

struct BookModel: Decodable {
    let title: String //책 제목
    let priceStandard: Int //정가
    let link: String // 책 판매 URL
    let cover: String // 책 표지 URL
}

struct FileModel: Decodable {
    let files: [String]
}

struct PostModel: Decodable {
    let post_id: String
    let product_id: String
    let content: String
    let content1: String
    let content2: String
    let content3: String
    let content4: String
    let files: [String]
    let hashTags: [String]
}

struct PostNetworkManager {
    
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
