//
//  MZConfirmBestieTableViewCell.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/15/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZConfirmBestieTableViewCell: UITableViewCell {

    @IBOutlet weak var bestieImageView: UIImageView!
    @IBOutlet weak var bestieNameLabel: UILabel!
    @IBOutlet weak var confirmBestieButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

