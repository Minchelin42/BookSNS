//
//  PostNetworkManager.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/13.
//

import Foundation
import RxSwift
import Alamofire

struct CommentModel: Decodable {
    let comment_id: String //댓글 ID
    let content: String //댓글 내용
    let creator: CreatorModel //작성자 정보
}

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
    let creator: CreatorModel?
    let files: [String]
    let likes: [String]
    let hashTags: [String]
    let comments: [CommentModel]
    
    enum CodingKeys: CodingKey {
        case post_id
        case product_id
        case content
        case content1
        case content2
        case content3
        case content4
        case creator
        case files
        case likes
        case hashTags
        case comments
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.post_id = try container.decode(String.self, forKey: .post_id)
        self.product_id = try container.decodeIfPresent(String.self, forKey: .product_id) ?? ""
        self.content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
        self.content1 = try container.decodeIfPresent(String.self, forKey: .content1) ?? ""
        self.content2 = try container.decodeIfPresent(String.self, forKey: .content2) ?? ""
        self.content3 = try container.decodeIfPresent(String.self, forKey: .content3) ?? ""
        self.content4 = try container.decodeIfPresent(String.self, forKey: .content4) ?? ""
        self.creator = try container.decodeIfPresent(CreatorModel.self, forKey: .creator) ?? nil
        self.files = try container.decodeIfPresent([String].self, forKey: .files) ?? []
        self.likes = try container.decodeIfPresent([String].self, forKey: .likes) ?? []
        self.hashTags = try container.decodeIfPresent([String].self, forKey: .hashTags) ?? []
        self.comments = try container.decodeIfPresent([CommentModel].self, forKey: .comments) ?? []
    }
}

struct LikeModel: Decodable {
    let like_status: Bool
}

struct CreatorModel: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String
    
    enum CodingKeys: CodingKey {
        case user_id
        case nick
        case profileImage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user_id = try container.decode(String.self, forKey: .user_id)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
    }
}

struct GetPostModel: Decodable {
    let data: [PostModel]
}

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
                let urlRequest = try PostRouter.getPost.asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<420)
                    .responseDecodable(of: GetPostModel.self) { response in
                        switch response.result {
                        case .success(let getPostModel):
//                            print("게시글 조회 성공", getPostModel)
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
