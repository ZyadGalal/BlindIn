//
//  MZAuthViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZAuthViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    let logIn = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZLoginViewController") as! MZLoginViewController
    let signUp = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZSignUpViewController") as! MZSignUpViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logInButton.isSelected = true
        logInButton.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 255/255, alpha: 1.0)
        self.addChild(logIn)
        self.containerView.addSubview(logIn.view)
        logIn.didMove(toParent: self)
        self.addChild(logIn)
        self.logIn.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func authButtonClicked(_ sender: UIButton) {
        removeChild()
        logInButton.isSelected = false
        signUpButton.isSelected = false
        
        logInButton.backgroundColor = UIColor.white
        signUpButton.backgroundColor = UIColor.white
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 255/255, alpha: 1.0)
        if sender == logInButton
        {
            self.addChild(logIn)
            self.containerView.addSubview(logIn.view)
            logIn.didMove(toParent: self)
            self.addChild(logIn)
            self.logIn.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
        }
        else if sender == signUpButton
        {
            self.addChild(signUp)
            self.containerView.addSubview(signUp.view)
            signUp.didMove(toParent: self)
            self.addChild(signUp)
            self.signUp.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
        }
    }

}
extension UIViewController {
    
    func removeChild() {
        self.children.forEach {
            $0.didMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
}
