//
//  Router.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/03/01.
//

import Foundation
import UIKit

//画面遷移の処理をViewControllerから切り離すクラス
//1. ViewContollerなどでRouterの画面遷移の処理を呼び出す。
//2. RouterはModelやPresenterを初期化しTransitionerの処理を呼び出し、画面遷移する。
//3. 結果として画面遷移の処理はPresenterとTransitionerが担うのでviewControllerから画面遷移の処理を切り出せる

final class Router {
    
    static let shared = Router()
    private init() {}
    
    private var window: UIWindow?
    
    func showDetailView(from: UIViewController, issue: Issue) {
        let vc = DetailViewController.makeFromStoryboard()
        let viewModel = DetailViewModel(issue: issue)
        vc.inject(viewModel: viewModel)
        show(from: from, to: vc)
    }
    
    private func show(from: UIViewController, to: UIViewController, completion:(() -> Void)? = nil){
        if let nav = from.navigationController {
            nav.pushViewController(to, animated: true)
            completion?()
        } else {
            from.present(to, animated: true, completion: completion)
        }
    }
}
