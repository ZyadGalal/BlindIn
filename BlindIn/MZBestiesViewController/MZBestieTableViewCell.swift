//
//  MZBestieTableViewCell.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/3/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZBestieTableViewCell: UITableViewCell {

    @IBOutlet weak var bestieImageView: UIImageView!
    @IBOutlet weak var bestieNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
