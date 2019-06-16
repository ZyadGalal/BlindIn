//
//  MZHangoutMembersLimitViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/14/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZHangoutMembersLimitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let name = UIBarButtonItem(title: "Next", style: .plain, target: self, action:#selector(tapButton) )
        self.navigationItem.setRightBarButton(name, animated: false)
        // Do any additional setup after loading the view.
    }
    

    @objc func tapButton(){
        //let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZInviteMembersViewController") as! MZInviteMembersViewController
        //self.navigationController?.pushViewController(vc, animated: true)
    }

}
