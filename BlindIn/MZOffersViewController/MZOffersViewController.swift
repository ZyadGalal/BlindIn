//
//  MZOffersViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/4/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP

class MZOffersViewController: UIViewController {
    

    var offers = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    
    @IBOutlet weak var offersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        offersTableView.register(UINib(nibName: "MZOffersTableViewCell", bundle: nil), forCellReuseIdentifier: "MZOffersTableViewCell")

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        Meteor.meteorClient?.addSubscription("offers.all")
        
        NotificationCenter.default.addObserver(self, selector: #selector(MZOffersViewController.offerssAdded), name: NSNotification.Name(rawValue: "offers_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZOffersViewController.offersUpdated), name: NSNotification.Name(rawValue: "offers_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZOffersViewController.offersRemoved), name: NSNotification.Name(rawValue: "offers_removed"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("offers.all")
        NotificationCenter.default.removeObserver(self)
    }
    
    func reload(tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
    
    
    @objc func offerssAdded (){
        offers = (Meteor.meteorClient?.collections["offers"] as? M13MutableOrderedDictionary)!
        print(offers)
        reload(tableView: offersTableView)
    }
    @objc func offersUpdated (){
        offers = (Meteor.meteorClient?.collections["offers"] as? M13MutableOrderedDictionary)!
        print(offers)
        reload(tableView: offersTableView)
    }
    @objc func offersRemoved (){
        offers = (Meteor.meteorClient?.collections["offers"] as? M13MutableOrderedDictionary)!
        print(offers)
        reload(tableView: offersTableView)
    }
    
}

extension MZOffersViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(offers.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = offersTableView.dequeueReusableCell(withIdentifier: "MZOffersTableViewCell") as! MZOffersTableViewCell
        if Meteor.meteorClient?.collections["offers"] != nil{
        let currentIndex = offers.object(at: UInt(indexPath.row))
        cell.offersNameLabel.text = (currentIndex["title"] as! String)
        cell.offersImageView.kf.indicatorType = .activity
        cell.offersImageView.kf.setImage(with: URL(string: currentIndex["image"] as! String))
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let current = offers.object(at: UInt(indexPath.row))
        let claims = current["claims"] as! [String]
        
        if claims.contains(Meteor.meteorClient!.userId)
        {
            let alert = UIAlertController(title: "Alert", message: "You Already Claim That Offer", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZOffersDetailsViewController") as! MZOffersDetailsViewController
            let currentIndex = offers.object(at: UInt(indexPath.row))
            vc.offerTitle = currentIndex["title"] as! String
            vc.offerDesc = currentIndex["description"] as! String
            vc.Image = currentIndex["image"] as! String
            vc.offerID = currentIndex["_id"] as! String
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
