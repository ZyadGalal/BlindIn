//
//  ZGEditProfileViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/18/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP

class ZGEditProfileViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    var lists = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        Meteor.meteorClient?.addSubscription("users.mine")
        NotificationCenter.default.addObserver(self, selector: #selector (ZGEditProfileViewController.getUsersInfo), name: NSNotification.Name(rawValue: "users_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (ZGEditProfileViewController.getUsersInfo), name: NSNotification.Name(rawValue: "useres_removed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (ZGEditProfileViewController.getUsersInfo), name: NSNotification.Name(rawValue: "users_changed"), object: nil)
    }
    
    @objc func getUsersInfo(){
        self.lists = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
        print(lists)
        let currentIndex = lists.object(at: UInt(0))
        let profile = currentIndex["profile"]
        //let firstName = profile["firstName"]
        
        
        
        print("HI")
        print(profile!!)

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
