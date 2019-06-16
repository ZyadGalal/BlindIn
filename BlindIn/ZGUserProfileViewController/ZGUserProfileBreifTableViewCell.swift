//
//  ZGUserProfileBreifTableViewCell.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class ZGUserProfileBreifTableViewCell: UITableViewCell {

    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var followViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hangoutsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLbl: UILabel!
    @IBOutlet weak var followView: UIView!
    @IBOutlet weak var userDescription: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
