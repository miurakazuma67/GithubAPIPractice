//
//  IssueListTableViewCell.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/02/14.
//

import UIKit
import Kingfisher

final class IssueListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userUrlLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(issue: Issue) {
        userUrlLabel.text = issue.user.login
        titleLabel.text = issue.title
        dateLabel.text = issue.updatedAt
        userImageView.kf.setImage(with: issue.user.avatarURL)
    }
}
