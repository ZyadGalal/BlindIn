//
//  MZBestiesViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/3/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP

class MZBestiesViewController: UIViewController {
    
    var besties = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    
    @IBOutlet weak var bestieTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let name = UIBarButtonItem(title: "Add Bestie +", style: .plain, target: self, action:#selector(tapButton))
        name.tintColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
        self.navigationItem.setRightBarButton(name, animated: false)
        bestieTableView.register(UINib(nibName: "MZBestieTableViewCell", bundle: nil), forCellReuseIdentifier: "MZBestieTableViewCell")
        // Do any additional setup after loading the view.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        Meteor.meteorClient?.addSubscription("users.besties")
        
        NotificationCenter.default.addObserver(self, selector: #selector(MZBestiesViewController.bestiesAdded), name: NSNotification.Name(rawValue: "besties_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZBestiesViewController.bestiesUpdated), name: NSNotification.Name(rawValue: "besties_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZBestiesViewController.bestiesRemoved), name: NSNotification.Name(rawValue: "besties_removed"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("users.besties")
        NotificationCenter.default.removeObserver(self)
    }
    
    func reload(tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
    
    
    @objc func bestiesAdded (){
        besties = (Meteor.meteorClient?.collections["besties"] as? M13MutableOrderedDictionary)!
        print(besties)
        reload(tableView: bestieTableView)
    }
    @objc func bestiesUpdated (){
        besties = (Meteor.meteorClient?.collections["besties"] as? M13MutableOrderedDictionary)!
        print(besties)
        reload(tableView: bestieTableView)
    }
    @objc func bestiesRemoved (){
        besties = (Meteor.meteorClient?.collections["besties"] as? M13MutableOrderedDictionary)!
        print(besties)
        reload(tableView: bestieTableView)
    }
    

    @objc func tapButton(){
        print("Add New Bestie")
        let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZAddBestiesViewController") as! MZAddBestiesViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}

extension MZBestiesViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(besties.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bestieTableView.dequeueReusableCell(withIdentifier: "MZBestieTableViewCell") as! MZBestieTableViewCell
        let current = besties.object(at: UInt(indexPath.row))
        let profile = current["profile"] as! [String : Any]
        cell.bestieNameLabel.text = "\(profile["firstName"] as! String) \(profile["lastName"] as! String)"
        cell.bestieImageView.kf.indicatorType = .activity
        cell.bestieImageView.kf.setImage(with: URL(string: profile["image"] as! String))
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            if Meteor.meteorClient?.connected == true{
                let current = besties.object(at: UInt(indexPath.row))
                var id = ""
                id = current["_id"] as! String
            
                Meteor.meteorClient?.callMethodName("users.methods.invite-bestie", parameters: [["userId" : id]], responseCallback: { (response, error) in
                    if error != nil{
                        print(error)
                    }
                    else{
                        print(response)
                        self.bestieTableView.reloadData()
                    }
                })
            }
            else{
                print("not connected")
            }
            }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let current = besties.object(at: UInt(indexPath.row))
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZGUserProfileViewController") as! ZGUserProfileViewController
        vc.id = current["_id"] as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
