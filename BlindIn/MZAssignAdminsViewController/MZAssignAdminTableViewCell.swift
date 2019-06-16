//
//  MZAssignAdminTableViewCell.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/4/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZAssignAdminTableViewCell: UITableViewCell {

    @IBOutlet weak var adminImageView: UIImageView!
    @IBOutlet weak var adminNameLabel: UILabel!
    @IBOutlet weak var assignButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
