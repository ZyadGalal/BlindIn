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
    
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.followBackButton.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
        self.selectionStyle = .none

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
