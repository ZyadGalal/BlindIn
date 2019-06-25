//
//  MZHangoutMembersLimitViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/14/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import TextFieldEffects

class MZHangoutMembersLimitViewController: UIViewController {
    
    var genders = ["Male" , "Female"]
    var genderPicker = UIPickerView()
    
    var hangTitle : String = ""
    var hangStartDate : String = ""
    var hangEndDate : String = ""
    var hangPublic : String = ""
    var hangWithRequest : String = ""
    var hangLocationID : String = ""
    var hangMax : String = ""
    var hangGender : String = ""
    var hangDesc : String = ""
    var hangInterests : [String] = []
    //---------------------Custom Location
    var locationName : String = ""
    var locationType : String = ""
    var locationAdress : String = ""
    var lat : String = ""
    var long : String = ""
    var city : String = ""
    var country : String = ""
    
    @IBOutlet weak var maxMembersLimitTextField: HoshiTextField!
    @IBOutlet weak var genderTextField: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderTextField.inputView = genderPicker
        
        

        let name = UIBarButtonItem(title: "Next", style: .plain, target: self, action:#selector(tapButton) )
        self.navigationItem.setRightBarButton(name, animated: false)
        // Do any additional setup after loading the view.
    }
    


    @objc func tapButton(){

        let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZInviteFromCollectionViewController") as! MZInviteFromCollectionViewController
        let mapVc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZInviteFromMapViewController") as! MZInviteFromMapViewController
        
        mapVc.hangTitle = hangTitle
        mapVc.hangStartDate = hangStartDate
        mapVc.hangEndDate = hangEndDate
        mapVc.hangPublic = hangPublic
        mapVc.hangWithRequest = hangWithRequest
        if hangLocationID != "" {
            mapVc.hangLocationID = hangLocationID
        }
        else{
            mapVc.locationName = locationName
            mapVc.locationAdress = locationAdress
            mapVc.locationType = locationType
            mapVc.lat = lat
            mapVc.long = long
            mapVc.city = city
            mapVc.country = country
        }
        
        mapVc.hangDesc = hangDesc
        mapVc.hangInterests = hangInterests
        mapVc.hangMax = maxMembersLimitTextField.text!
        mapVc.hangGender = genderTextField.text!
        
        //---------------------------------------------
        
        vc.hangTitle = hangTitle
        vc.hangStartDate = hangStartDate
        vc.hangEndDate = hangEndDate
        vc.hangPublic = hangPublic
        vc.hangWithRequest = hangWithRequest
        if hangLocationID != "" {
            vc.hangLocationID = hangLocationID
        }
        else{
            vc.locationName = locationName
            vc.locationAdress = locationAdress
            vc.locationType = locationType
            vc.lat = lat
            vc.long = long
            vc.city = city
            vc.country = country
        }
        vc.hangDesc = hangDesc
        vc.hangInterests = hangInterests
        vc.hangMax = maxMembersLimitTextField.text!
        vc.hangGender = genderTextField.text!
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func genderTextFieldClicked(_ sender: Any) {
        genderTextField.text = genders[0]
        genderPicker.selectRow(0, inComponent: 0, animated: true)
    }
}

extension MZHangoutMembersLimitViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genders[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    
}
