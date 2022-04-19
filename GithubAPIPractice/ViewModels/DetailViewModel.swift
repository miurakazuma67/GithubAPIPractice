//
//  IssueListViewModel.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/02/26.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel {
    
    private let disposeBag = DisposeBag()
    
    /*Outputに関する記述*/
    //outputsはinputsでViewControllerから受け取ったイベントによって処理をして、その結果をViewControllerに返すのでObservableを使う。
    let title: Driver<String>
    let body: Driver<String>
    let url: Driver<URL>
    let updatedAt: Driver<String>
    
    init(issue: Issue) {
        //justは、単一のものを流すことができる
        self.title = Driver.just(issue.title)
        self.body = Driver.just(issue.body)
        self.url = Driver.just(issue.url)
        self.updatedAt = Driver.just(issue.updatedAt)
    }
}
