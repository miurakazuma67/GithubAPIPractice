//
//  ViewController.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/02/12.
//

import UIKit
import RxSwift
import RxCocoa

//github issueからとってきたissue一覧を表示するViewController(Viewの役割)

//    View -> ViewModel: セルタップのイベントを伝える
//    ViewModel -> View: 画面遷移を行うようにイベントを発行する（次の画面で必要なパラメーターがあれば、このイベントで渡します）
//    View: 画面遷移する

//インジケーターを通信中に表示するのと、
//エラー時に再表示ボタンを表示するのができてないです。
//通信結果に応じて、Button.isHiddenを切り替えたら実装できる？

//一覧画面 tapしたら詳細画面に飛ばす
final class IssueListViewController: UIViewController {
    
    //modelのインスタンス
    private var viewModel = IssueListViewModel()
    private let disposeBag = DisposeBag()
    private lazy var output: IssueListViewModelOutput = viewModel
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.viewDidLoad()
        tableView.registerCustomCell(IssueListTableViewCell.self)
        showIndicator()
        setupBindings()
    }

    private func setupBindings() {
        viewModel.shouldReload.emit(onNext: { [weak self] in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }

    //request -> 表示の間だけくるくる回るようにしたいが、実装できなかったです
    //出てきたけどよくわからなかったもの "https://github.com/ReactiveX/RxSwift/blob/main/RxExample/RxExample/Services/ActivityIndicator.swift"
    
    private func showIndicator() {
        // isAnimatingのフラグをIndicatorのisAnimatingに連携させる
        viewModel.showLoading.asDriver()
            .drive(indicatorView.rx.isAnimating)
        //ここまではブレーク貼ってもちゃんと止まるのに、くるくる回らない
            .disposed(by: disposeBag)
        // isAnimatingのフラグをIndicatorのisHiddenに連携させる
        viewModel.showLoading.asDriver()
            .map { !$0 }
            .drive(indicatorView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    
}

extension IssueListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //issueに値が入っていない？
        let issue = viewModel.cellContent(at: indexPath)
        let cell = tableView.dequeueReusableCustomCell(with: IssueListTableViewCell.self)
        cell.setUp(issue: issue)
        return cell
    }
}

extension IssueListViewController: UITableViewDelegate {
    
    
}
