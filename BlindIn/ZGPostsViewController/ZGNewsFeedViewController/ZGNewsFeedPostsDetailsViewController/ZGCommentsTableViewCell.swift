//
//  ZGCommentsTableViewCell.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/18/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class ZGCommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
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
