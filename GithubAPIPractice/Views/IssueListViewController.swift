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
        viewModel.shouldReload.emit(onNext: { [weak self] in //Signalを購読するときはemit
            self?.tableView.reloadData() //shouldReloadの変更を感知し、再描画を行う
        }).disposed(by: disposeBag)
    }
    
//    weak self キャプチャ漏れを確認するための参考
//    private func cellTapped() {
//        // tableViewのセルをタップした時のメソッド
//        tableView.rx.itemSelected
//            .subscribe(onNext: { [weak self] indexPath in
//                guard let strongSelf = self else { return }
//                //詳細画面に飛ばす
//                //値渡しもする
//                Router.shared.showDetailView(from: strongSelf)
//            })
//            .disposed(by: disposeBag)
//    }
    
    private func showIndicator() {
        // isAnimatingのフラグをIndicatorのisAnimatingに連携させる
        viewModel.isIndicatorVisible.asDriver()
            .drive(indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

extension IssueListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let issue = viewModel.cellContent(at: indexPath)
        let cell = tableView.dequeueReusableCustomCell(with: IssueListTableViewCell.self)
        cell.setUp(issue: issue)
        return cell
    }
}

extension IssueListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let issue = viewModel.cellContent(at: indexPath)
        Router.shared.showDetailView(from: self, issue: issue)
    }
}
