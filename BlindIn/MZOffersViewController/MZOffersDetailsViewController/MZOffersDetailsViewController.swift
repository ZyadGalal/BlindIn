//
//  MZOffersDetailsViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZOffersDetailsViewController: UIViewController {
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var offerNameLabel: UILabel!
    @IBOutlet weak var offerDetailsTextView: UITextView!
    @IBOutlet weak var getOfferButton: UIButton!
    
    var OfferImage = UIImage()
    var offerName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        offerNameLabel.text = offerName
        offerImageView.image = OfferImage
        // Do any additional setup after loading the view.
    }
    
}
