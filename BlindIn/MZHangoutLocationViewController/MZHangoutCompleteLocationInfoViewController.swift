//
//  MZHangoutCompleteLocationInfoViewController.swift
//  BlindIn
//
//  Created by Moustafa on 6/20/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import TextFieldEffects

class MZHangoutCompleteLocationInfoViewController: UIViewController {

    @IBOutlet weak var locationTitleTextField: HoshiTextField!
    @IBOutlet weak var locationTypeTextField: HoshiTextField!
    @IBOutlet weak var locationAdressTextField: HoshiTextField!
    
    var locationName = ""
    var locationType = ""
    var locationAdress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationAdressTextField.text = locationAdress
        locationTypeTextField.text = locationType
        locationTitleTextField.text = locationName
        
        // Do any additional setup after loading the view.
    }

}
