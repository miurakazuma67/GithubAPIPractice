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
    private let disposeBag = DisposeBag()

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
    private func bind() {
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
    
    //画面遷移用
    static func makeFromStoryboard()->DetailViewController {
        UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController() as! DetailViewController
    }

}
