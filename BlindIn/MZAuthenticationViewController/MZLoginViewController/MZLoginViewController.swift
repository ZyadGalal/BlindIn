//
//  MZLoginViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import TextFieldEffects

class MZLoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func forgetPasswordButtonTapped(_ sender: Any) {
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        if usernameTextField.text != "" && passwordTextField.text != "" {
            if Meteor.meteorClient?.connected == true {
                Meteor.meteorClient?.logon(withEmail: usernameTextField.text!, password: passwordTextField.text!, responseCallback: { (response, error) in
                    if error != nil{
                        print(error!)
                    }
                    else{
                        print(response!)

                        let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZBestiesViewController") as! MZBestiesViewController
                        
                        

                        self.navigationController?.pushViewController(vc, animated: true)

                    }
                })
            }
            else{
                print("not connected")
            }
        }
        
        
    }
    

}
