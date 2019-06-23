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
    
    var textFieldName : HoshiTextField!
    let datePicker = UIDatePicker()
    let hangoutCreationInfo = HangoutCreation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = UIBarButtonItem(title: "Next", style: .plain, target: self, action:#selector(tapButton) )
        self.navigationItem.setRightBarButton(name, animated: false)
        createDatePicker()
        hangoutCreationModel()
       
    }
    
    func hangoutCreationModel() {
        hangoutCreationInfo.title = hangoutTitleTextField.text!
        //Location
        hangoutCreationInfo.startDate = startDateTextField.text!
        hangoutCreationInfo.endDate = endDateTextField.text!
        if hangoutPrivacySwitch.isOn {
            hangoutCreationInfo.isPublic = "true"
        }
        else {
            hangoutCreationInfo.isPublic = "false"
        }
        if requestToJoinSwitch.isOn {
            hangoutCreationInfo.requireRequest = "true"
        }
        else {
            hangoutCreationInfo.requireRequest = "false"
        }
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
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressedOnDatePicker()
    {

        let formate = DateFormatter()
        formate.dateFormat = "yyyy-M-dd"
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
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
