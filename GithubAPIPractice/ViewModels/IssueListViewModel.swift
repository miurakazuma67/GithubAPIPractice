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
    //privateで流したい
    //このままだと、ViewControllerからshowLoadingを流すことができてしまう
    var dataRelay: BehaviorRelay<[SectionModel]> { get }

    //各種View用の出力情報をDriverとして出力することができると尚良い
}

final class IssueListViewModel: IssueListViewModelOutput {
    
    private let disposeBag = DisposeBag()
    private var sectionModel: [SectionModel]!

    //(refs: "https://stackoverflow.com/questions/54213183/display-activity-indicator-with-rxswift-and-mvvm")
    
//    privateをつけないと、ViewController側からViewModel内のshowLoadingに対して直接acceptしてデータを流すことが出来てしまいます。
    private let showLoadingRelay = BehaviorRelay<Bool>(value: true)
    var showLoading: Driver<Bool> {
        showLoadingRelay.asDriver()
    }

    
    /*Outputに関する記述*/
    //ここもDriverに変換できる？
    lazy var dataRelay = BehaviorRelay<[SectionModel]>(value: [])
    //↓だとうまくいかなかった
//    private var dataRelay = BehaviorRelay<[SectionModel]>(value: [])
//    var dataDriver: Driver<[SectionModel]> {
//        dataRelay.asDriver()
//    }
    
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
        showLoadingRelay.accept(true)
        
        GithubApiModel.shared.rx.request()
            .map { repositories -> [SectionModel] in
                [SectionModel(items: repositories)]
            }
    //dateRelayに新しいSectionModelを流すと勝手にreloadしてくれる
    .bind(to: dataRelay)
    .disposed(by: disposeBag)
    
        showLoadingRelay.accept(false)
    }

}
