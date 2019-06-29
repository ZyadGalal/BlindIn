//
//  MZNearbyMemberCollectionViewCell.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/2/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZNearbyMemberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nearbyMemberImageView: UIImageView!
    @IBOutlet weak var nearbyMemberNameLabel: UILabel!
    
    override var isSelected: Bool{
        didSet {
            self.nearbyMemberImageView.borderWidth = 3.0
            self.nearbyMemberImageView.borderColor = isSelected ? UIColor(red: 61/255, green: 101/255, blue: 255/255, alpha: 1.0)  : UIColor(red: 111/255.0, green: 113/255.0, blue: 121/255.0, alpha: 1.0)
        }
    }
}
