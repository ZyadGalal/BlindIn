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
    
    var genders = ["Male" , "Female"]
    var genderPicker = UIPickerView()

    @IBOutlet weak var withRequestUISwitch: UISwitch!
    @IBOutlet weak var chatUISwitch: UISwitch!
    @IBOutlet weak var genderTextField: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderTextField.inputView = genderPicker

        // Do any additional setup after loading the view.
    }
    
    @IBAction func allowedMembersButton(_ sender: Any) {
        let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZAllowedMemberViewController") as! MZAllowedMemberViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func assignAdminsButton(_ sender: Any) {
        let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZAssignAdminViewController") as! MZAssignAdminViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    @IBAction func editHangoutDetailsButtonPressed(_ sender: Any) {
    }
    @IBAction func genderTextFieldClicked(_ sender: Any) {
        genderTextField.text = genders[0]
        genderPicker.selectRow(0, inComponent: 0, animated: true)
    }
    

}

extension MZHangoutSettingViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    
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
