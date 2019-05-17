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

    @IBOutlet weak var startDateTextField: HoshiTextField!
    @IBOutlet weak var endDateTextField: HoshiTextField!
    
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
        toolbar.setItems([done], animated: true)

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
    

    @IBAction func dateTextFieldClicked(_ sender: HoshiTextField) {
        textFieldName = sender
    }
    
    
    
    
    @objc func tapButton(){
        let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZHangoutDescriptionViewController") as! MZHangoutDescriptionViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
