//
//  Repository.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/02/17.
//

import Foundation
import RxSwift

struct Repository: Codable {
    let items: [Issue]
}
   
/// GitHubのissueの情報
struct Issue: Codable {
    let number: Int
    let title: String // 一覧画面・詳細画面に表示
    let body: String // 詳細画面に表示
    let url: URL // 詳細画面に表示し、それをタップしたらSafariViewControllerで開く
    let user: User // 一覧画面にアバター画像と名前を表示
    let updatedAt: String // 一覧画面・詳細画面に表示
    
    enum CodingKeys: String, CodingKey {
        case number
        case title
        case body
        case url
        case user
        case updatedAt = "updated_at"
    }
    
}

protocol Decodable {
    init(from decoder: Decoder) throws
}

protocol Encodable {
    func encode(to encoder: Encoder) throws
}

//TODO: rename(itemを)
///列にデコードしたモデルをアプリ内で受け渡しながら使いまわすよりも、その配列をプロパティとして持つモデルにマッピングしたいことがある場合に必要な拡張
extension Repository: Decodable {
    init(from decoder: Decoder) throws {
        var items: [Issue] = []
        var unkeyedContainer = try decoder.unkeyedContainer()
        while !unkeyedContainer.isAtEnd {
            let item = try unkeyedContainer.decode(Issue.self)
            items.append(item)
        }
        self.init(items: items)
    }
}

extension Repository: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for item in items {
            try container.encode(item)
        }
    }
}
