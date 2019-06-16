//
//  MZFollowBackTableViewCell.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/15/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZFollowBackTableViewCell: UITableViewCell {

    @IBOutlet weak var followerImageView: UIImageView!
    @IBOutlet weak var followerNameLabel: UILabel!
    @IBOutlet weak var followBackButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
