//
//  TableView +.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/02/17.
//

import Foundation
import UIKit

extension UITableView {

    func registerCustomCell<T: UITableViewCell>(_ cellType: T.Type) {
        register(
            UINib(nibName: T.identifier, bundle: nil),
            forCellReuseIdentifier: T.identifier
        )
    }

    func dequeueReusableCustomCell<T: UITableViewCell>(with cellType: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier) as! T
    }
}
