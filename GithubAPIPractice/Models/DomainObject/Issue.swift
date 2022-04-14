//
//  Issue.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/04/13.
//

import Foundation

/// GitHubのissueの情報
struct Issue {
    let number: Int
    let title: String // 一覧画面・詳細画面に表示
    let body: String // 詳細画面に表示
    let url: URL // 詳細画面に表示し、それをタップしたらSafariViewControllerで開く
    let user: User // 一覧画面にアバター画像と名前を表示
    let updatedAt: String // 一覧画面・詳細画面に表示
    //Date型のまま流すと、Viewで加工する必要がある


}
