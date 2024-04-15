//
//  SearchBook.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/14.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

struct SearchBookModel: Decodable {
    let item: [BookModel]
}

class SearchBookNetwork {
    
    static func searchBook(router: SearchBookRouter) -> Single<[BookModel]> {
        return Single<[BookModel]>.create { single in

            AF.request(router.baseURL,
                       method: router.method,
                       parameters: router.parameter,
                       encoding: URLEncoding(destination: .queryString))
                .response { response in
                    guard let responseData = response.data else {
                        print("응답 데이터가 없습니다.")
                        return
                    }
                    
                    var responseString = String(data: responseData, encoding: .utf8) ?? ""
                    // 세미콜론 제거
                    responseString = responseString.replacingOccurrences(of: ";", with: "")
                    
                    guard let cleanedData = responseString.data(using: .utf8) else {
                        print("세미콜론 제거 후 데이터 변환 실패")
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let bookModel = try decoder.decode(SearchBookModel.self, from: cleanedData)
                        print("책 받아오기 성공", bookModel)
                        // 성공한 경우
                        single(.success(bookModel.item))
                    } catch {
                        // 실패한 경우
                        print("책 받아오기 실패", error)
                        single(.failure(error))
                    }
                }

            return Disposables.create()
        }
    }
    
}

enum SearchBookRouter {
    
    case searchBook(title: String)
}

extension SearchBookRouter {
    var baseURL: String {
        return APIKey.bookURL.rawValue
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameter: Parameters {
        switch self {
        case .searchBook(let title):
            return ["ttbkey" : APIKey.bookKey.rawValue, "Query" : title, "Output" : "JS"]
        }
    }
}
