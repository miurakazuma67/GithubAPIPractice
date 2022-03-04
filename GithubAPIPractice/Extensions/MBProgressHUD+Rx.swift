//
//  a.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/03/04.
//

import UIKit
import MBProgressHUD
import RxSwift
import RxCocoa

//RxSwiftで使うための拡張

extension Reactive where Base: MBProgressHUD {
    static func isAnimating(view: UIView) -> AnyObserver<Bool> {
        return AnyObserver { event in
            switch event {
            case .next(let value):
                if value {
                    MBProgressHUD.showAdded(to: view, animated: true)
                } else {
                    MBProgressHUD.hide(for: view, animated: true)
                }
            default:
                break
            }
        }
    }
}

