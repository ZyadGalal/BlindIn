//
//  MZAllowedMemberViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/3/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZAllowedMemberViewController: UIViewController {

    @IBOutlet weak var allowedMembersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = UIBarButtonItem(title: "Done", style: .plain, target: self, action:#selector(tapButton))
        name.tintColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
        self.navigationItem.setRightBarButton(name, animated: false)

        allowedMembersTableView.register(UINib(nibName: "MZAllowedMemberTableViewCell", bundle: nil), forCellReuseIdentifier: "MZAllowedMemberTableViewCell")
        // Do any additional setup after loading the view.
    }
    @objc func tapButton(){
        print("The Allowing Members")
    }
}


extension MZAllowedMemberViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allowedMembersTableView.dequeueReusableCell(withIdentifier: "MZAllowedMemberTableViewCell") as! MZAllowedMemberTableViewCell
        cell.usernameLabel.text = "momen adel mohamed"
        cell.selectionStyle = .none
        cell.allowButton.addTarget(self, action: #selector(checkMarkButtonClicked(sender:)), for: .touchUpInside)
        cell.allowButton.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
        return cell
    }
    
    
    @objc func checkMarkButtonClicked (sender : UIButton){
        print("Button Clicked")
        if sender.isSelected{
            sender.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
            sender.isSelected = false
        }
        else{
            sender.setTitle("Disallow", for: .selected)
            sender.borderColor = UIColor.gray
            sender.isSelected = true
        }
    }
}
