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
    let hangoutCreationInfo = HangoutCreation()
    
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
    
    func hangoutCreationModel() {
        hangoutCreationInfo.max = maxMembersLimitTextField.text!
        hangoutCreationInfo.gender = genderTextField.text!
    }

    @objc func tapButton(){
        hangoutCreationModel()
        let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZInviteFromCollectionViewController") as! MZInviteFromCollectionViewController
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
