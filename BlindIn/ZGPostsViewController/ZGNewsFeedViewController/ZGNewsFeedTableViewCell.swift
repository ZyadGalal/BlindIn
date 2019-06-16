//
//  ZGNewsFeedTableViewCell.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/4/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class ZGNewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var hangDescriptionLabel: UILabel!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var hangImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
