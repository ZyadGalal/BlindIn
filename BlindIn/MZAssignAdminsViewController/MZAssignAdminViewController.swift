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
        
        let name = UIBarButtonItem(title: "Done", style: .plain, target: self, action:#selector(tapButton))
        name.tintColor = UIColor(red:58/255.0, green:97/255.0, blue:249/255.0, alpha:1.00)
        self.navigationItem.setRightBarButton(name, animated: false)

        assignAdminTabelView.register(UINib(nibName: "MZAssignAdminTableViewCell", bundle: nil), forCellReuseIdentifier: "MZAssignAdminTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    @objc func tapButton(){
        print("Finish Assigning Admins")
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
        cell.assignButton.borderColor = UIColor(red: 61/255, green: 101/255, blue: 255/255, alpha: 1.0)
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
            sender.borderColor = UIColor(red: 61/255, green: 101/255, blue: 255/255, alpha: 1.0)
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
