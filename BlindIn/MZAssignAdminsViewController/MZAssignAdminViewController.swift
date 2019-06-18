//
//  MZAssignAdminViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/4/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZAssignAdminViewController: UIViewController {

    @IBOutlet weak var assignAdminTabelView: UITableView!
    
    var name = ["Momen","Momen Adel","Momen Adel Mohamed","Mo2a","El Mo2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assignAdminTabelView.register(UINib(nibName: "MZAssignAdminTableViewCell", bundle: nil), forCellReuseIdentifier: "MZAssignAdminTableViewCell")
        // Do any additional setup after loading the view.
    }
    
}

extension MZAssignAdminViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = assignAdminTabelView.dequeueReusableCell(withIdentifier: "MZAssignAdminTableViewCell") as! MZAssignAdminTableViewCell
        cell.adminNameLabel.text = name[indexPath.row]
        cell.selectionStyle = .none
        cell.assignButton.addTarget(self, action: #selector(checkMarkButtonClicked(sender:)), for: .touchUpInside)
        cell.assignButton.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            name.remove(at: indexPath.row)
            assignAdminTabelView.reloadData()
        }
    }
    
    
    @objc func checkMarkButtonClicked (sender : UIButton){
        print("Button Clicked")
        if sender.isSelected{
            sender.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
            //sender.setTitle("Disallow", for: .selected)
            sender.isSelected = false
        }
        else{
            sender.setTitle("Assigned", for: .selected)
            sender.borderColor = UIColor.gray
            sender.isSelected = true
        }
    }
}
