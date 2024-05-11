//
//  UserDefaultsInfo.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/11.
//

import Foundation

enum UserDefaultsInfo {
    static let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
    static let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    static let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
    static let profileImage = UserDefaults.standard.string(forKey: "profileImage") ?? ""
    static let nick = UserDefaults.standard.string(forKey: "nick") ?? ""
    static let email = UserDefaults.standard.string(forKey: "email") ?? ""
}
