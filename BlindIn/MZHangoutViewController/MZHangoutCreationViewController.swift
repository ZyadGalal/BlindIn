//
//  MZHangoutCreationViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import TextFieldEffects
import UIKit

class MZHangoutCreationViewController: UIViewController {

    @IBOutlet weak var hangoutPrivacySwitch: UISwitch!
    @IBOutlet weak var requestToJoinSwitch: UISwitch!
    @IBOutlet weak var startDateTextField: HoshiTextField!
    @IBOutlet weak var endDateTextField: HoshiTextField!
    @IBOutlet weak var hangoutTitleTextField: HoshiTextField!
    
    var locationID : String = ""
    var locationName : String = ""
    var locationType : String = ""
    var locationAdress : String = ""
    var lat : String = ""
    var long : String = ""
    var city : String = ""
    var country : String = ""
    var textFieldName : HoshiTextField!
    let datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = UIBarButtonItem(title: "Next", style: .plain, target: self, action:#selector(tapButton) )
        self.navigationItem.setRightBarButton(name, animated: false)
        createDatePicker()
        
    }
    
    
    func createDatePicker ()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action:#selector(donePressedOnDatePicker))
        var flexableSpece = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        done.tintColor = UIColor.black
        toolbar.setItems([flexableSpece,done], animated: true)


        datePicker.minimumDate = Date()
        startDateTextField.inputView = datePicker
        startDateTextField.inputAccessoryView = toolbar
        endDateTextField.inputView = datePicker
        endDateTextField.inputAccessoryView = toolbar
        datePicker.datePickerMode = .dateAndTime
    }
    
    @objc func donePressedOnDatePicker()
    {

        
        let formate = DateFormatter()
        formate.dateFormat = "yyyy-M-dd HH:MM"
        if textFieldName == startDateTextField
        {
            print("hi")
        startDateTextField.text = formate.string(from: datePicker.date)
        }
        else{
            print("no")
        endDateTextField.text = formate.string(from: datePicker.date)
        }
        textFieldName = nil

        self.view.endEditing(true)

    }
    
    @objc func tapButton(){
        let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZHangoutDescriptionViewController") as! MZHangoutDescriptionViewController
        vc.hangTitle = hangoutTitleTextField.text!
        if locationID != "" {
            vc.hangLocationID = locationID
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
        
        print(locationID)
        vc.hangStartDate = startDateTextField.text!
        vc.hangEndDate = endDateTextField.text!
        if hangoutPrivacySwitch.isOn {
            vc.hangPublic = "true"
        }
        else {
            vc.hangPublic = "false"
        }
        if requestToJoinSwitch.isOn {
            vc.hangWithRequest = "true"
        }
        else {
            vc.hangWithRequest = "false"
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    @IBAction func dateTextFieldClicked(_ sender: HoshiTextField) {
        textFieldName = sender
    }
    
    @IBAction func privacySwitchPressed(_ sender: Any) {
        print(hangoutPrivacySwitch.isOn)
    }
    
    @IBAction func requestToJoinSwitchPressed(_ sender: Any) {
        print(requestToJoinSwitch.isOn)
    }
    
    
    @IBAction func locationButtonClicked(_ sender: Any) {

        let vc = UIStoryboard(name: "Third", bundle: nil).instantiateViewController(withIdentifier: "MZHangoutSetLocationViewController") as! MZHangoutSetLocationViewController
        vc.locationIDDelegate = self

        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
extension MZHangoutCreationViewController : PassLocationBackward{
    func passData(locID: String) {
        locationID = locID
        print(locationID)
    }
    func passData(locationsName: String, locationsType: String, locationsAdress: String, locationsLat: String, locationsLng: String, city: String, country: String){
        locationName = locationsName
        locationType = locationsType
        locationAdress = locationsAdress
        lat = locationsLat
        long = locationsLng
        self.city = city
        self.country = country
    }
}

//extension MZHangoutSetLocationViewController : passCompleteLocation{
//    func passData(locationsName: String, locationsType: String, locationsAdress: String, locationsLat: String, locationsLng: String, city: String, country: String) {
//        locationName = locationsName
//
//    }
//
//
//
//
////        self.locationName = locationName
////        self.locationType = locationType
////        self.locationAdress = locationAdress
////        self.lat = locationLat
////        self.long = locationLng
////        self.city = city
////        self.country = country
//
//
//}


