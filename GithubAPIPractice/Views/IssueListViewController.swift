//
//  ViewController.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/02/12.
//

import UIKit
import RxSwift
import RxCocoa

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
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.shouldReload.emit(onNext: { [weak self] in // Signalを購読するときはemit
            self?.tableView.reloadData() // shouldReloadの変更を感知し、再描画を行う
        }).disposed(by: disposeBag)
        
 // isAnimatingのフラグをIndicatorのisAnimatingに連携させる
        viewModel.isIndicatorVisible.asDriver()
            .drive(indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.requestedShowAlertAndRetry
            .emit(onNext: { [weak self] _ in
                let alert: UIAlertController = UIAlertController(title: "エラー", message: "通信に失敗しました", preferredStyle:  UIAlertController.Style.alert)

                let defaultAction: UIAlertAction = UIAlertAction(title: "リトライ", style: UIAlertAction.Style.default, handler:{

                    (action: UIAlertAction!) -> Void in
                    self?.viewModel.viewDidLoad()
                })

                let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{

                    (action: UIAlertAction!) -> Void in
                })

                alert.addAction(cancelAction)
                alert.addAction(defaultAction)

                self?.present(alert, animated: true, completion: nil)
            })
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
