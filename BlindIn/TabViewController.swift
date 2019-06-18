//
//  TabViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/18/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(true, animated: false)
    }

}
