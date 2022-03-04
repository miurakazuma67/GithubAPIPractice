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
    //RxDataSources
    //画面遷移する際に値を渡す
    var dataRelay: BehaviorRelay<[SectionModel]> { get }
    // 検索中か
//    var isLoading: Observable<Bool> { get }
}

final class IssueListViewModel: IssueListViewModelOutput {
    
    private let disposeBag = DisposeBag()
    private var sectionModel: [SectionModel]!

    //(refs: "https://stackoverflow.com/questions/54213183/display-activity-indicator-with-rxswift-and-mvvm")
    let showLoading = BehaviorRelay<Bool>(value: true)
    
    /*Outputに関する記述*/
    lazy var dataRelay = BehaviorRelay<[SectionModel]>(value: [])
    
    init() {
        sectionModel = [SectionModel(items: [])]
        
        //dataRelayに初期設定のsectionModelを流す
        Observable.deferred { () -> Observable<[SectionModel]> in
            return Observable.just(self.sectionModel)
        }.bind(to: dataRelay)
        .disposed(by: disposeBag)
        
    }
    
    
    //errorを書くとしたらここ？
    //ViewModelからエラーを受け取って、Viewでアラートやボタンの表示を行いたい
    func requestGithubIssue() {
        showLoading.accept(true)
        
        GithubApiModel.shared.rx.request()
            .map { repositories -> [SectionModel] in
                [SectionModel(items: repositories)]
            }
    //dateRelayに新しいSectionModelを流すと勝手にreloadしてくれる
    .bind(to: dataRelay)
    .disposed(by: disposeBag)
    
        showLoading.accept(false)
    }

}
