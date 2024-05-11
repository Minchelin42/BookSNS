//
//  SignUpQuery.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/11.
//

import Foundation

struct SignUpQuery: Encodable {
    let email: String
    let password: String
    let nick: String
}
