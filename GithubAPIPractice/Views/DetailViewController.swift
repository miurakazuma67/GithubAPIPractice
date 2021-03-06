//
//  DetailViewController.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/03/01.
//

import UIKit
import RxSwift
import RxCocoa

// 詳細画面
final class DetailViewController: UIViewController {
    
    // modelのインスタンス
    private var viewModel: DetailViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var urlButton: UIButton!
    @IBOutlet private weak var updatedAtLabel: UILabel!
    
    // viewModelを外部から渡す
    func inject(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }

    // labelにIssueListViewControllerから受け取ったIssueを元に、表示を行う
    private func setupBindings() {
        self.viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.body
            .drive(bodyLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.updatedAt
            .drive(updatedAtLabel.rx.text)
            .disposed(by: disposeBag)

        self.viewModel.url
            .map{$0 .absoluteString}
            .drive(urlButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    // 画面遷移用
    static func makeFromStoryboard()->DetailViewController {
        UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController() as! DetailViewController
    }

}
