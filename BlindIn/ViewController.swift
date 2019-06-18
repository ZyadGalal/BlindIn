//
//  ViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/4/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let time = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (time) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }


}

