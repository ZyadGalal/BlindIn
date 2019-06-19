//
//  MZInterestsCollectionViewCell.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZInterestsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var interestImageView: UIImageView!
    @IBOutlet weak var interestLabel: UILabel!
    
    override var isSelected: Bool{
        didSet {
            self.interestImageView.borderWidth = 3.0
            self.interestImageView.borderColor = isSelected ? UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)  : UIColor(red: 111/255.0, green: 113/255.0, blue: 121/255.0, alpha: 1.0) 
        }
    }
}
