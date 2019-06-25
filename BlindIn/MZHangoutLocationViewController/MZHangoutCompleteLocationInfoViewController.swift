//
//  MZHangoutCompleteLocationInfoViewController.swift
//  BlindIn
//
//  Created by Moustafa on 6/20/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import TextFieldEffects

protocol PassLocationInfo {
    func passData(locationName : String , locationType : String , locationAdress : String , locationLat : String , locationLng : String , city : String , country : String)
}

class MZHangoutCompleteLocationInfoViewController: UIViewController {

    @IBOutlet weak var locationTitleTextField: HoshiTextField!
    @IBOutlet weak var locationTypeTextField: HoshiTextField!
    @IBOutlet weak var locationAdressTextField: HoshiTextField!
    
    var locationName = ""
    var locationType = ""
    var locationAdress = ""
    var lat = ""
    var long = ""
    var city = ""
    var country = ""
    
    var Delegate : PassLocationInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIBarButtonItem(title: "Done", style: .plain, target: self, action:#selector(tapButton))
        btn.tintColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
        self.navigationItem.setRightBarButton(btn, animated: false)

        locationAdressTextField.text = locationAdress
        
        
        // Do any additional setup after loading the view.
    }
    @objc func tapButton(){
        locationName = locationTitleTextField.text!
        locationType = locationTypeTextField.text!
        if locationTitleTextField.text != "" && locationTypeTextField.text != "" && locationAdressTextField.text != "" {
            print("Done Pressed")
            print(locationName)
            print(locationType)
            print(locationAdress)
            print(lat)
            print(long)
            print(city)
            print(country)

            Delegate.passData(locationName: "locationName", locationType: "locationType", locationAdress: locationAdress, locationLat: lat, locationLng: long, city: city, country: country)
            let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZHangoutCreationViewController") as! MZHangoutCreationViewController
            self.navigationController?.popToViewController(vc, animated: true)
        }else{
            print("FILL")
        }
    }
}
