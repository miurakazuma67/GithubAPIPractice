//
//  DetailViewController.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/03/01.
//

import UIKit
import RxSwift
import RxCocoa

//詳細画面
final class DetailViewController: UIViewController {
    
    //modelのインスタンス
    private var viewModel: DetailViewModel!
    private var disposeBag = DisposeBag()

    private lazy var output: DetailViewModelOutput = viewModel
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var urlButton: UIButton!
    @IBOutlet private weak var updatedAtLabel: UILabel!
    
    //viewModelを外部から渡す
    func inject(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }

    //labelにIssueListViewControllerから受け取ったIssueを元に、表示を行う
    func bind() {
        self.viewModel.title
            .bind(to: self.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.body
            .bind(to: self.bodyLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.updatedAt
            .bind(to: self.updatedAtLabel.rx.text)
            .disposed(by: disposeBag)
        //textViewにリンク埋め込みでWebView開くように実装したかったが、やり方わからなかったのでボタンに表示している
        self.viewModel.url
            .map{$0 .absoluteString}
            .bind(to: urlButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    
//    func show() {
//        urlButton.rx.tap
//ここで、ボタンタップ時にissueを渡し、urlを元に通信処理を行いたかったが、実装できてません。
//urlを渡して遷移させたい
//            .asSignal()
//            .emit(onNext: { item in
//                Router.shared.showWebView(from: self, issue: item)  //DetailVCを確認
//            }).disposed(by: disposeBag)
//    }
    
    //画面遷移用
    static func makeFromStoryboard()->DetailViewController {
        UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController() as! DetailViewController
    }

}
