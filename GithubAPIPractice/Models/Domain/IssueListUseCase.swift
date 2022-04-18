//
//  UseCase.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/04/13.
//

import RxSwift
import RxRelay

//publicで書く理由: VMから参照したいから(repositoryからは参照しない)

public class IssueListUseCase {

    private let disposeBag = DisposeBag()
    //repositoryをGithubIssuesRepositoryProtocolに適合させる(testableにするため)
    private let repository: GithubIssuesRepositoryProtocol
    private let issuesRelay = BehaviorRelay<[Issue]?>(value: nil)
    //publicつかなかった
    var issues: Observable<[Issue]> {
        issuesRelay
            .compactMap { $0 }    //issuesRelayの中でnilじゃないものをissuesに入れ、
            .asObservable()    //Observableに変換する
    }

    init(repository: GithubIssuesRepositoryProtocol) {
        self.repository = repository
    }

    func fetch() {
        repository.fetch()   //repositoryからデータをとってくる
            .subscribe(onSuccess: { [weak self] in     //購読し、成功時に
                self?.issuesRelay.accept($0)    //issuesRelayの中にとってきたデータを入れていく
            })
            .disposed(by: disposeBag)    //講読破棄
    }
}
