//
//  ProfileQuery.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/11.
//

import Foundation

struct ProfileQuery: Encodable {
    var nick: String
    var profile: Data
}
