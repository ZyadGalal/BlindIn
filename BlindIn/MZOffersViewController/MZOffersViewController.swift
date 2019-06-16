//
//  MZOffersViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/4/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZOffersViewController: UIViewController {
    
    
    var offersName = ["Sale","Sale","Sale","Sale","Sale"]
    @IBOutlet weak var offersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        offersTableView.register(UINib(nibName: "MZOffersTableViewCell", bundle: nil), forCellReuseIdentifier: "MZOffersTableViewCell")

    }
    
    @objc func tapDetailsButton(){
        print("Hello")
        let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZOffersDetailsViewController") as! MZOffersDetailsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MZOffersViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offersName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = offersTableView.dequeueReusableCell(withIdentifier: "MZOffersTableViewCell") as! MZOffersTableViewCell
        cell.offersNameLabel.text = offersName[indexPath.row]
        cell.detailsButton.addTarget(self, action:#selector(tapDetailsButton), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    
}

