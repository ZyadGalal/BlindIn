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
import AWSS3
import AWSCore
import Kingfisher

class ZGEditProfileViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: HoshiTextField!
    @IBOutlet weak var lastNameTextField: HoshiTextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var birthDateTextField: HoshiTextField!
    
    var lists = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var datePicker = UIDatePicker()
    
    let imagePicker = UIImagePickerController()
    var currentUserImage : String?
    var didSelectNewImage : Bool = false
    let accessKey = "AKIAW5P6CHD4GNOTS7FM"
    let secretKey = "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"
    var params : [String: Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        imagePicker.delegate = self
        createDatePicker()
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        Meteor.meteorClient?.addSubscription("users.mine")
        NotificationCenter.default.addObserver(self, selector: #selector (ZGEditProfileViewController.getUsersInfo), name: NSNotification.Name(rawValue: "users_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (ZGEditProfileViewController.getUsersInfo), name: NSNotification.Name(rawValue: "users_removed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (ZGEditProfileViewController.getUsersInfo), name: NSNotification.Name(rawValue: "users_changed"), object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("users.mine")
        NotificationCenter.default.removeObserver(self)
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
        let currentIndex = lists.object(at: UInt(0)) as! [String:Any]
        
        let profile = currentIndex["profile"] as! [String : Any]
        
        let firstName = profile["firstName"]
        firstNameTextField.text = firstName! as? String
        let lastName = profile["lastName"]
        lastNameTextField.text = lastName! as? String
        let birthDate = profile["birthDate"]
        birthDateTextField.text = birthDate! as? String
        if didSelectNewImage == false{
            currentUserImage = profile["image"] as? String
        }
        userImageView.kf.setImage(with: URL(string: currentUserImage!))
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
        params = ["firstName" : firstNameTextField.text!,"lastName" : lastNameTextField.text! , "bio" : bioTextView.text! , "birthDate" : birthDateTextField.text!]
        if bioTextView.text != "" {
            params ["bio"] = "SWE"
        }
        if Meteor.meteorClient?.connected == true{
            if didSelectNewImage == true{
                uploadButtonPressed()
            }
            else{
                params["image"] = self.currentUserImage!
                self.navigationController?.popViewController(animated: true)
                self.updateProfile()
            }
        }
        else{
            print("not connected")
        }
    }
    
    func uploadButtonPressed() {
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("postImage.jpeg")
        let imageData = userImageView.image!.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: path as String, contents: imageData, attributes: nil)
        
        let timestamp = NSDate().timeIntervalSince1970
        
        let fileUrl = NSURL(fileURLWithPath: path)
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = "blendin-userfiles-mobilehub-1929261559"
        uploadRequest?.key = "jsaS3/\(timestamp).jpeg"
        uploadRequest?.contentType = "image/jpeg"
        uploadRequest?.body = fileUrl as URL
        uploadRequest?.acl = .publicRead
        uploadRequest?.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
            DispatchQueue.main.async(execute: {
                print(totalBytesSent) // To show the updating data status in label.
            })
        }
        
        
        let transferManager = AWSS3TransferManager.default()
        
        transferManager.upload(uploadRequest!).continueWith { (task :AWSTask<AnyObject>) -> Any? in
            if let error = task.error {
                print("Upload failed with error: (\(error.localizedDescription))")
            }
            
            if task.result != nil {
                let url = AWSS3.default().configuration.endpoint.url
                let publicURL = url?.appendingPathComponent(uploadRequest!.bucket!).appendingPathComponent(uploadRequest!.key!)
                self.currentUserImage = "\(publicURL!)"
                print("Uploaded to:\(publicURL)")
                DispatchQueue.main.async {
                    self.params["image"] = self.currentUserImage
                    self.updateProfile()
                    
                }
            }
            return nil
        }
        
    }
    func updateProfile (){
        Meteor.meteorClient?.callMethodName("users.methods.update-profile", parameters: [params], responseCallback: { (response, error) in
            if error != nil{
                print(error)
            }
            else{
                print(response)
                self.didSelectNewImage = false
            }
        })
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
        userImageView.image = ResizeImage.resizeTo(image: chosenImage, maxSize: 300) //4
        didSelectNewImage = true
        dismiss(animated: true, completion: nil) //5
    }
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
