//
//  UseCase.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/04/13.
//

import RxSwift
import RxRelay

// publicで書く理由: VMから参照したいから(repositoryからは参照しない)

public class IssueListUseCase {

    private let disposeBag = DisposeBag()
    // repositoryをGithubIssuesRepositoryProtocolに適合させる(testableにするため)
    private let repository: GithubIssuesRepositoryProtocol
    private let issuesRelay = BehaviorRelay<[Issue]?>(value: nil)
    // privateをつけないと、ViewController側からViewModel内のshowLoadingに対して直接acceptしてデータを流すことが出来てしまいます。
    private let isProcessingRelay = BehaviorRelay<Bool>(value: true)
    // indicator用のstream
    var isProcessing: Observable<Bool> {
        isProcessingRelay.asObservable()
    }

    private let informFailureRelay = PublishRelay<Void>()
    // error通知用のstream
    var informFailure: Observable<Void> {
        informFailureRelay.asObservable()
    }

    // publicつかなかった
    var issues: Observable<[Issue]> {
        issuesRelay
            .compactMap { $0 } // issuesRelayの中でnilじゃないものをissuesに入れ、
            .asObservable() // Observableに変換する
    }

    init(repository: GithubIssuesRepositoryProtocol) {
        self.repository = repository
    }

    func fetch() {
        isProcessingRelay.accept(true)
        repository.fetch() // repositoryからデータをとってくる
            .subscribe(
                onSuccess: { [weak self] in // 購読し、成功時に
                    self?.issuesRelay.accept($0) // issuesRelayの中にとってきたデータを入れていく
                    self?.isProcessingRelay.accept(false) // indicatorの表示もストップ
                },
                onFailure: { [weak self] _ in // _ を置く順番と、必要な理由(onFailure時にはエラーを渡すが、使わないことを明示したいからアンダースコアを置く)
                    self?.isProcessingRelay.accept(false) // 通信失敗時に、falseを流さないといけない
                    self?.informFailureRelay.accept(()) // 通信失敗時に、falseを流さないといけない
                }
            )
            .disposed(by: disposeBag) // 講読破棄
    }
}
