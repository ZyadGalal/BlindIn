//
//  ZGMoreTableViewCell.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/17/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class ZGMoreTableViewCell: UITableViewCell {

    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var moreImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
