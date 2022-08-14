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


final class IssueListViewModel {
    
    private let disposeBag = DisposeBag()
    private var issue: [Issue]!
    private let useCase = IssueListUseCase(repository: GithubIssuesRepository())
    
    // indicator用のstream
    // UseCaseは進行中かどうか以外は知らない(通信中かどうかは知らない)ので、命名を工夫する
    // これはVCでも使うので、表示のされ方も考慮した命名にする
    // VM -> VでUI表示を意識するので、Driverは出てくるとしたらVM (UseCaseでは出てこない)
    var isIndicatorVisible: Driver<Bool> {
        useCase.isProcessing.asDriver(onErrorJustReturn: false)
    }

    var requestedShowAlertAndRetry: Signal<Void> {
        useCase.informFailure.asSignal(onErrorSignalWith: .empty())
    }

    // useCaseから流れてきた値を入れるためのBehaviorRelay
    private let issueListRelay = BehaviorRelay<[Issue]>(value: [])
    // Viewで監視するための、外部公開用のObservable
    // 中でSignalに変換
    var issueListStream: Signal<[Issue]> { issueListRelay.asSignal(onErrorRecover: { _ in .empty() })
    }

    // useCase.issuesが流れてきたのを、ViewController側に通知する仕組み
    //  ViewControllerでは、それ(shouldReload)を購読してreloadData()
    var shouldReload: Signal<Void> {
        useCase.issues
            .map { _ in () }
            .asSignal(onErrorSignalWith: .empty())
    }

    init() {
        setupBindings()
    }

    func viewDidLoad() {
        fetchGithubIssue()
    }

    // useCaseから流れてきたissuesをissueListRelayに入れる
    private func setupBindings() {
        useCase.issues.subscribe(onNext: { [weak self] in
            self?.issueListRelay.accept($0)
        }).disposed(by: disposeBag)
    }

    func cellContent(at indexPath: IndexPath) -> Issue {
        return issueListRelay.value[indexPath.row]
    }

    func numberOfRows() -> Int {
        return issueListRelay.value.count
    }

    // ViewModelからエラーを受け取って、Viewでアラートやボタンの表示を行いたい
    func fetchGithubIssue() {
        useCase.fetch()
    }
}
