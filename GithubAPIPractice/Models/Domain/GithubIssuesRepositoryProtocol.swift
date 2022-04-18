//
//  GithubIssuesRepositoryProtocol.swift
//  GithubAPIPractice
//
//  Created by Kazuma Miura on 2022/04/18.
//

import Foundation
import RxSwift

protocol GithubIssuesRepositoryProtocol {
    func fetch() -> Single<[Issue]>
}
