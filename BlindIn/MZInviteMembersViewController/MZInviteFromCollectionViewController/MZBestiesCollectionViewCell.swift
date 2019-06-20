//
//  MZBestiesCollectionViewCell.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/2/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZBestiesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bestieImageView: UIImageView!
    @IBOutlet weak var bestieNameLabel: UILabel!
    override var isSelected: Bool{
        didSet {
            self.bestieImageView.borderWidth = 3.0
            self.bestieImageView.borderColor = isSelected ? UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)  : UIColor(red: 111/255.0, green: 113/255.0, blue: 121/255.0, alpha: 1.0)
        }
    }
}
