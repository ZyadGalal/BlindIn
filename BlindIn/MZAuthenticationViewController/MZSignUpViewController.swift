//
//  MZSignUpViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZSignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func signUpClicked(_ sender: Any) {
        let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZInterestsViewController") as! MZInterestsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
