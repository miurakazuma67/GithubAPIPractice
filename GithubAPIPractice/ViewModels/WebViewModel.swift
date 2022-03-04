//
//  WebViewModel.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/03/03.
//

import Foundation
import RxSwift
import RxCocoa

//受け取ったurlを元に、WebViewにURLRequestを飛ばす

protocol  WebViewModelOutput {
    //URLRequest
    var request: URLRequest { get }
}

final class WebViewModel: WebViewModelOutput {
    
    /*Outputに関する記述*/
    let request: URLRequest
    
    init(issue: Issue) {
        
        self.request = URLRequest(url: issue.url)
    }
}

