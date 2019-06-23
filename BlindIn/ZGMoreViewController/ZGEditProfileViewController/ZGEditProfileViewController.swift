//
//  ZGEditProfileViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/18/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP
import TextFieldEffects

class ZGEditProfileViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: HoshiTextField!
    @IBOutlet weak var lastNameTextField: HoshiTextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var birthDateTextField: UITextView!
    
    var lists = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var datePicker = UIDatePicker()
    
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createDatePicker()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        Meteor.meteorClient?.addSubscription("users.mine")
        NotificationCenter.default.addObserver(self, selector: #selector (ZGEditProfileViewController.getUsersInfo), name: NSNotification.Name(rawValue: "users_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (ZGEditProfileViewController.getUsersInfo), name: NSNotification.Name(rawValue: "users_removed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (ZGEditProfileViewController.getUsersInfo), name: NSNotification.Name(rawValue: "users_changed"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("users.mine")
        NotificationCenter.default.removeObserver(self)
        lists.removeAllObjects()
    }
    
    func createDatePicker ()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action:#selector(donePressedOnDatePicker))
        var flexableSpece = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        done.tintColor = UIColor.black
        toolbar.setItems([flexableSpece,done], animated: true)
        birthDateTextField.inputView = datePicker
        birthDateTextField.inputAccessoryView = toolbar
        datePicker.datePickerMode = .date
    }
    @objc func donePressedOnDatePicker()
    {
        
        let formate = DateFormatter()
        formate.dateFormat = "yyyy-M-dd"
        birthDateTextField.text = formate.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
    
    @objc func getUsersInfo(){
        self.lists = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
        print(lists)
        let currentIndex = lists.object(at: UInt(0))
        let profile = currentIndex["profile"]! as! [String : Any]
        let firstName = profile["firstName"]
        firstNameTextField.text = firstName! as! String
        let lastName = profile["lastName"]
        lastNameTextField.text = lastName! as! String
        let birthDate = profile["birthDate"]
        birthDateTextField.text = birthDate! as! String
        print("HI")

    }
    
    

    @IBAction func changePhotoButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        var params : [String : String] = [:]
        params = ["firstName" : firstNameTextField.text!,"lastName" : lastNameTextField.text! , "bio" : bioTextView.text! , "birthDate" : birthDateTextField.text!]
        if bioTextView.text != "" {
            params ["bio"] = "SWE"
        }
        if Meteor.meteorClient?.connected == true{
            Meteor.meteorClient?.callMethodName("users.methods.update-profile", parameters: [params], responseCallback: { (response, error) in
                if error != nil{
                    print(error)
                }
                else{
                    print(response)
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        else{
            print("not connected")
        }
    }
    
}
extension ZGEditProfileViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate
{
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage //2
        userImageView.contentMode = .scaleAspectFill //3
        userImageView.image = chosenImage //4
        dismiss(animated: true, completion: nil) //5
    }
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
