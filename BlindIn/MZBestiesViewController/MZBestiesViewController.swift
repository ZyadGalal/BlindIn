//
//  MZBestiesViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/3/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZBestiesViewController: UIViewController {
    
    var name = ["Momen","Momen Adel","Momen Adel Mohamed","Mo2a","El Mo2"]

    @IBOutlet weak var bestieTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = UIBarButtonItem(title: "Add Bestie", style: .plain, target: self, action:#selector(tapButton))
        self.navigationItem.setRightBarButton(name, animated: false)

        bestieTableView.register(UINib(nibName: "MZBestieTableViewCell", bundle: nil), forCellReuseIdentifier: "MZBestieTableViewCell")
        // Do any additional setup after loading the view.
    }
    @objc func tapButton(){
        print("Add New Bestie")
        
    }

}

extension MZBestiesViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bestieTableView.dequeueReusableCell(withIdentifier: "MZBestieTableViewCell") as! MZBestieTableViewCell
        cell.selectionStyle = .none
        cell.bestieNameLabel.text = name[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            name.remove(at: indexPath.row)
            bestieTableView.reloadData()
        }
    }
    
    
}
