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
        
        let btn = UIBarButtonItem(title: "Done", style: .plain, target: self, action:#selector(tapButton))
        btn.tintColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
        self.navigationItem.setRightBarButton(btn, animated: false)

        locationAdressTextField.text = locationAdress
        locationTypeTextField.text = locationType
        locationTitleTextField.text = locationName
        
        // Do any additional setup after loading the view.
    }
    @objc func tapButton(){
        print("Done Pressed")            
            let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZHangoutCreationViewController") as! MZHangoutCreationViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }

}
