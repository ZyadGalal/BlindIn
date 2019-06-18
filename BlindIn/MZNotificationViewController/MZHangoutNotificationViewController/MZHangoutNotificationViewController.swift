//
//  MZHangoutNotificationViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/15/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZHangoutNotificationViewController: UIViewController {

    @IBOutlet weak var hangoutNotificationTableView: UITableView!
    
    var name = ["Momen","Momen Adel","Momen Adel Mohamed","Mo2a","El Mo2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hangoutNotificationTableView.register(UINib(nibName: "MZHangoutNotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "MZHangoutNotificationTableViewCell")
        hangoutNotificationTableView.register(UINib(nibName: "MZHangoutAddPostTableViewCell", bundle: nil), forCellReuseIdentifier: "MZHangoutAddPostTableViewCell")
        // Do any additional setup after loading the view.
    }
    
}


extension MZHangoutNotificationViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hangoutNotificationTableView.dequeueReusableCell(withIdentifier: "MZHangoutNotificationTableViewCell") as! MZHangoutNotificationTableViewCell
        let addPostCell = hangoutNotificationTableView.dequeueReusableCell(withIdentifier: "MZHangoutAddPostTableViewCell") as! MZHangoutAddPostTableViewCell
        
//        if (cell.notificationType == Hangout invitation){}
        cell.selectionStyle = .none
        
        cell.userNameLabel.text = name[indexPath.row]
        cell.acceptButton.addTarget(self, action: #selector(checkMarkButtonClicked(sender:)), for: .touchUpInside)
        cell.acceptButton.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
        return cell
//        else{}
//        addPostCell.selectionStyle = .none
//        addPostCell.userNameLabel.text = name[indexPath.row]
//        return addPostCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            name.remove(at: indexPath.row)
            hangoutNotificationTableView.reloadData()
        }
    }
    
    
    @objc func checkMarkButtonClicked (sender : UIButton){
        print("Button Clicked")
        if sender.isSelected{
            sender.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
            sender.backgroundColor = UIColor.white
            sender.isSelected = false
        }
        else{
            sender.setTitle("Accepted", for: .selected)
            sender.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
            sender.backgroundColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
            sender.isSelected = true
        }
    }
    
}
