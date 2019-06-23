//
//  MZHangoutDescriptionViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZHangoutDescriptionViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = UIBarButtonItem(title: "Next", style: .plain, target: self, action:#selector(tapButton) )
        self.navigationItem.setRightBarButton(name, animated: false)

        // Do any additional setup after loading the view.
    }
    
    @objc func tapButton(){
        let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZHangoutMembersLimitViewController") as! MZHangoutMembersLimitViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
