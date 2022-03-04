//
//  ViewController.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/02/12.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

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
    private var disposeBag = DisposeBag()
    private lazy var output: IssueListViewModelOutput = viewModel
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCustomCell(IssueListTableViewCell.self)
        setUpTableView()
        animate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //通信と同期して、インジケータを回す方法がわからなかった
        viewModel.requestGithubIssue()
    }
    
    func setUpTableView() {
        
        //RxDataSources
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCustomCell(with: IssueListTableViewCell.self)
            cell.setUp(issue: item)
            
            return cell
        })
        
        //dateRelayの変更を感知してdataSourceにデータを流す
        output.dataRelay.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //cellをタップしたら画面遷移したい
        //VCヘの遷移でViewModelのインスタンスを作るときに
        //データを渡してあげたい場合はinitに投げる
        
        //tableViewのセルをタップした時の処理
        tableView.rx.modelSelected(Issue.self)
            .subscribe(onNext: { item in
                Router.shared.showDetailView(from: self, issue: item)
                //ここでデータを渡す
            }).disposed(by: disposeBag)
        
    }
    
    //request -> 表示の間だけくるくる回るようにしたいが、実装できなかったです
    //出てきたけどよくわからなかったもの "https://github.com/ReactiveX/RxSwift/blob/main/RxExample/RxExample/Services/ActivityIndicator.swift"
    
    func animate() {
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
