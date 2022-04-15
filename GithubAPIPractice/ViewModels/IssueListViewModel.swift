//
//  DetailViewModel.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/02/26.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol IssueListViewModelOutput {
    var issueListStream: Signal<[Issue]> { get }
}

final class IssueListViewModel: IssueListViewModelOutput {
    
    private let disposeBag = DisposeBag()
    private var issue: [Issue]!
    private let useCase = IssueListUseCase()
    
    //    privateをつけないと、ViewController側からViewModel内のshowLoadingに対して直接acceptしてデータを流すことが出来てしまいます。
    private let showLoadingRelay = BehaviorRelay<Bool>(value: true)
    //indicator用のstream
    var showLoading: Driver<Bool> {
        showLoadingRelay.asDriver()
    }
    /*Outputに関する記述*/
    private let issueListRelay = BehaviorRelay<[Issue]>(value: [])
    //Viewで監視するための、readOnlyのObservable
    var issueListStream: Signal<[Issue]> { issueListRelay.asSignal(onErrorRecover: { _ in .empty() })
    }
    
    init() {
        setupBindings()
    }
    
    //TODO: APIリクエストを投げる(VM -> UseCase)
    func viewDidLoad() {
        fetchGithubIssue()
    }
    
    //useCaseから流れてきたissuesをissueListRelayに入れる
    private func setupBindings() {
        useCase.issues.subscribe(onNext: { [weak self] in
            self?.issueListRelay.accept($0)
            print($0)
        }).disposed(by: disposeBag)
    }
    
    func cellContent(at indexPath: IndexPath) -> Issue {
        issueListRelay.value[indexPath.row]
    }
    
    func numberOfRows() -> Int {
        issueListRelay.value.count
    }

    //ViewModelからエラーを受け取って、Viewでアラートやボタンの表示を行いたい
    func fetchGithubIssue() {
        showLoadingRelay.accept(true)
        useCase.fetch()
        showLoadingRelay.accept(false)
    }
}
