//
//  GithubApiModel.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/02/18.
//

import Foundation
import RxSwift

final class GithubIssuesRepository: GithubIssuesRepositoryProtocol {
    //UseCaseでのエラーを防ぐためにpublic指定
    public init () {}

    ///リクエスト
    func fetch() -> Single<[Issue]> {
        Single.create { observer in

            let url = URL(string: "https://api.github.com/repos/rails/rails/issues")!
            let task: URLSessionTask = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                do{
                    let result = try JSONDecoder().decode([IssueDTO].self, from: data)
                    observer(.success(
                        result.compactMap {
                            Issue(
                                number: $0.number,
                                title: $0.title,
                                body: $0.body,
                                url: $0.url,
                                user: .init(login: $0.user.login, avatarURL: $0.user.avatarURL),
                                updatedAt: $0.updatedAt
                            )
                        }
                    ))
                }
                catch {
                    //これでerrorになったことが伝わる
                    observer(.failure(error))
                }
            }
            task.resume()
            return Disposables.create {}
        }
    }
}

extension GithubIssuesRepository: ReactiveCompatible{}

// DTO -> 可変。外から変更可能
// 異なるレイヤー間(Model層、View層など)でデータを受け渡す際に使う
private struct IssueDTO: Decodable {
    let number: Int
    let title: String // 一覧画面・詳細画面に表示
    let body: String // 詳細画面に表示
    let url: URL // 詳細画面に表示し、それをタップしたらSafariViewControllerで開く
    let user: UserDTO // 一覧画面にアバター画像と名前を表示
    let updatedAt: String // 一覧画面・詳細画面に表示
    // Date型のまま流すと、Viewで加工する必要がある

    enum CodingKeys: String, CodingKey {
        case number
        case title
        case body
        case url
        case user
        case updatedAt = "updated_at"
    }
}

private struct UserDTO: Decodable {
    let login: String
    let avatarURL: URL
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
