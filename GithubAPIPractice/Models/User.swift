//
//  User.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/02/28.
//

import Foundation

///// Githubのuser情報
struct User: Codable {
    let login: String
    let avatarURL: URL

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
