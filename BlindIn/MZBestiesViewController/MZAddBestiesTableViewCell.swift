//
//  MZAddBestiesTableViewCell.swift
//  BlindIn
//
//  Created by Moustafa on 6/27/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZAddBestiesTableViewCell: UITableViewCell {

    @IBOutlet weak var addBestieImageView: UIImageView!
    @IBOutlet weak var addUsernameLabel: UILabel!
    @IBOutlet weak var addBestieButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
