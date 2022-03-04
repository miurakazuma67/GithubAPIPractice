//
//  WebViewController.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/03/02.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import RxOptional

final class WebViewController: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    
    private var viewModel: WebViewModel!
    private let disposeBag = DisposeBag()

    //viewModelを外部から渡す
    func inject(viewModel: WebViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //webViewの進捗とprogressViewのprogressをbindする
        webView.rx.observe(Double.self, "estimatedProgress")
            .filterNil()
            .map{ return Float($0)}
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
        
        //webViewのloadingをprogressViewにbindする
        webView.rx.observe(Bool.self, "loading")
            .filterNil()
            .map { !$0 }
            .bind(to: progressView.rx.isHidden)
            .disposed(by: disposeBag)
        
        webView.load(viewModel.request)
    }
    
    static func makeFromStoryboard()->WebViewController {
        UIStoryboard(name: "WebView", bundle: nil).instantiateInitialViewController() as! WebViewController
    }
}
