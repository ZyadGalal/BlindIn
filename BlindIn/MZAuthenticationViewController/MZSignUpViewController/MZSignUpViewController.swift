//
//  MZSignUpViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import TextFieldEffects

class MZSignUpViewController: UIViewController {
    
 
    var genders = ["Male" , "Female"]
    var genderPicker = UIPickerView()
    var datePicker = UIDatePicker()
    
    @IBOutlet weak var firstNameTextField: HoshiTextField!
    @IBOutlet weak var lastNameTextField: HoshiTextField!
    @IBOutlet weak var genderTextField: HoshiTextField!
    @IBOutlet weak var dateOfBirthTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var confirmPasswordTextField: HoshiTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderTextField.inputView = genderPicker
//        dateOfBirthTextField.inputView = datePicker
//        datePicker.datePickerMode = .date
        createDatePicker()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func genderTextFieldClicked(_ sender: Any) {
        genderTextField.text = genders[0]
        genderPicker.selectRow(0, inComponent: 0, animated: true)
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        if firstNameTextField.text != "" && lastNameTextField.text != "" && emailTextField.text != "" && passwordTextField.text != "" && genderTextField.text != "" && dateOfBirthTextField.text != "" && confirmPasswordTextField.text != ""{
            if passwordTextField.text! == confirmPasswordTextField.text!{
                if Meteor.meteorClient?.connected == true
                {
                    signUp(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, gender: genderTextField.text!, birthdate: dateOfBirthTextField.text!)
                }
                else
                {
                    print("not connected")
                }
            }
            else
            {
                print("incorrect password")
            }
        }
        else{
            print("complete fields")
        }
    }
    func signUp(firstName : String ,lastName : String , email : String , password : String,gender:String,birthdate:String){
        Meteor.meteorClient?.signup(withUserParameters: ["email":email,"password":password,"profile":["firstName":firstName,"lastName":lastName,"gender":gender,"birthDate" : birthdate]], responseCallback: { (response, error) in
            if error != nil{
                print(error)
            }
            else{
                let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZInterestsViewController") as! MZInterestsViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    func createDatePicker ()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action:#selector(donePressedOnDatePicker))
        var flexableSpece = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        done.tintColor = UIColor.black
        toolbar.setItems([flexableSpece,done], animated: true)
        dateOfBirthTextField.inputView = datePicker
        dateOfBirthTextField.inputAccessoryView = toolbar
        datePicker.datePickerMode = .date
    }
    @objc func donePressedOnDatePicker()
    {
        
        let formate = DateFormatter()
        formate.dateFormat = "yyyy-M-dd"
        dateOfBirthTextField.text = formate.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
}
extension MZSignUpViewController : UIPickerViewDataSource , UIPickerViewDelegate{
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
