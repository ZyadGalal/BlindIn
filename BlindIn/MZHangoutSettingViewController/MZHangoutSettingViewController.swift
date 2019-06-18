//
//  MZHangoutSettingViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/15/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import TextFieldEffects

class MZHangoutSettingViewController: UIViewController {
    
    var data = ["Male" , "Female"]
    var picker = UIPickerView()

    @IBOutlet weak var withRequestUISwitch: UISwitch!
    @IBOutlet weak var chatUISwitch: UISwitch!
    @IBOutlet weak var genderTextField: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self
        genderTextField.inputView = picker

        // Do any additional setup after loading the view.
    }
    @IBAction func allowedMembersTextFieldClicked(_ sender: Any) {
    }
    @IBAction func assignAdminsTextFieldClicked(_ sender: Any) {
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    @IBAction func editHangoutDetailsButtonPressed(_ sender: Any) {
    }
    

}

extension MZHangoutSettingViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = data[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    
}
