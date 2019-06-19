//
//  MZOffersViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/4/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit


class MZOffersViewController: UIViewController {
    
    
    var offersName = ["Sale","Sale 10%","Sale 20%","Sale 50%","Sale 100%"]
    var offerImages = ["1","1","1","1","1"]
    @IBOutlet weak var offersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        offersTableView.register(UINib(nibName: "MZOffersTableViewCell", bundle: nil), forCellReuseIdentifier: "MZOffersTableViewCell")

    }
    
   
    
}

extension MZOffersViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offersName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = offersTableView.dequeueReusableCell(withIdentifier: "MZOffersTableViewCell") as! MZOffersTableViewCell
        cell.offersNameLabel.text = offersName[indexPath.row]
        cell.offersImageView.image = UIImage(named: offerImages[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZOffersDetailsViewController") as! MZOffersDetailsViewController
        vc.OfferImage = UIImage(named: offerImages[indexPath.row])!
        vc.offerName = offersName[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
}
