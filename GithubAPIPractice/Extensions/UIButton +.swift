//
//  UIButton +.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/03/03.
//

import Foundation
import UIKit
import RxSwift

extension Reactive where Base: UIButton {

    /// Reactive wrapper for `setTitle(_:for:)`
    public func title(for controlState: UIControl.State = []) -> Binder<String?> {
        return Binder(self.base) { button, title -> Void in
            button.setTitle(title, for: controlState)
        }
    }
}

extension Reactive where Base: UIButton {

    /// Reactive wrapper for `setAttributedTitle(_:controlState:)`
    public func attributedTitle(for controlState: UIControl.State = []) -> Binder<NSAttributedString?> {
        return Binder(self.base) { button, attributedTitle -> Void in
            button.setAttributedTitle(attributedTitle, for: controlState)
        }
    }

}
