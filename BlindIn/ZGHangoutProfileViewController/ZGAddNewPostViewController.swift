//
//  ZGAddNewPostViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/20/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore
import ObjectiveDDP

class ZGAddNewPostViewController: UIViewController {

    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var postDescriptionTextView: UITextView!
    
    let imagePicker = UIImagePickerController()
    let accessKey = "AKIAW5P6CHD4GNOTS7FM"
    let secretKey = "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"
    var choosenPostImage = UIImage()
    var ImageURL = ""
    var hangoutId = "agKkwBDSZc6okbt8M"
    override func viewDidLoad() {
        super.viewDidLoad()
        postDescriptionTextView.text = "Post Description"
        postDescriptionTextView.textColor = UIColor.lightGray
        postDescriptionTextView.delegate = self
        
        imagePicker.delegate = self
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func uploadButtonPressed() {
            let fileManager = FileManager.default
            let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("postImage.jpeg")
            let imageData = choosenPostImage.jpegData(compressionQuality: 0.5)
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
                self.ImageURL = "\(publicURL!)"
                print("Uploaded to:\(publicURL)")
                DispatchQueue.main.async {
                    self.uploadPost()

                }
            }
            return nil
        }
        
    }
    func uploadPost(){
        if Meteor.meteorClient?.connected == true{
            Meteor.meteorClient?.callMethodName("posts.methods.create", parameters: [["hangoutId" : hangoutId,"image" : ImageURL , "description" : postDescriptionTextView.text!]], responseCallback: { (response, error) in
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
    @IBAction func postButtonClicked(_ sender: Any) {
        uploadButtonPressed()

    }
    @IBAction func addImageButtonClicked(_ sender: Any) {
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

extension ZGAddNewPostViewController : UITextViewDelegate{
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Post Description"
            textView.textColor = UIColor.lightGray
        }
    }

}
extension ZGAddNewPostViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate
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
        choosenPostImage = chosenImage
        addImageButton.setImage(chosenImage, for: .normal)
        addImageButton.setTitle("", for: .normal)
        dismiss(animated: true, completion: nil) //5
    }
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
