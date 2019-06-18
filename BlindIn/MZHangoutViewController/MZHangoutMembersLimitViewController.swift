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
    
    var data = ["Male" , "Female"]
    var picker = UIPickerView()
    
    @IBOutlet weak var maxMembersLimitTextField: HoshiTextField!
    @IBOutlet weak var genderTextField: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self
        genderTextField.inputView = picker

        let name = UIBarButtonItem(title: "Next", style: .plain, target: self, action:#selector(tapButton) )
        self.navigationItem.setRightBarButton(name, animated: false)
        // Do any additional setup after loading the view.
    }
    

    @objc func tapButton(){
        //let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZInviteMembersViewController") as! MZInviteMembersViewController
        //self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension MZHangoutMembersLimitViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    
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
