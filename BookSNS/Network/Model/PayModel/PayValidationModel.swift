//
//  PayValidationModel.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/11.
//

import Foundation

struct PayList: Decodable {
    var data: [PayValidationModel]
}

struct PayValidationModel: Decodable{
    var payment_id: String
    var buyer_id: String
    var post_id: String
    var merchant_uid: String
    var productName: String
    var price: Int
    var paidAt: String
}
