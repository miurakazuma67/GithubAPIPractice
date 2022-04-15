//
//  IssueListViewModel.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/02/26.
//

import Foundation
import RxSwift
import RxCocoa

//ボタンの入力を検知して、urlを元にしてrequestを行いたい

// ボタンの入力シーケンス
//struct DetailViewModelInput {
//    var urlButtonSelect: Observable<Void>
//}

protocol DetailViewModelOutput {
    
    var title: Observable<String> { get }
    var body: Observable<String> { get }
    var url: Observable<URL> { get }
    var updatedAt: Observable<String> { get }
}

final class DetailViewModel: DetailViewModelOutput {
    
    private let disposeBag = DisposeBag()
    
    /*Outputに関する記述*/
    //outputsはinputsでViewControllerから受け取ったイベントによって処理をして、その結果をViewControllerに返すのでObservableを使う。
    let title: Observable<String>
    let body: Observable<String>
    let url: Observable<URL>
    let updatedAt: Observable<String>
    
    init(issue: Issue) {
        //justは、単一のものを流すことができる
        self.title = Observable.just(issue.title)
        self.body = Observable.just(issue.body)
        self.url = Observable.just(issue.url)
        self.updatedAt = Observable.just(issue.updatedAt)
    }
}
