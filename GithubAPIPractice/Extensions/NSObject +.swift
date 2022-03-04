//
//  NSObject +.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/02/17.
//

import Foundation

extension NSObjectProtocol {

    static var className: String {
        return String(describing: self)
    }
}
