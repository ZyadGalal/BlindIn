//
//  MZAddBestiesViewController.swift
//  BlindIn
//
//  Created by Moustafa on 6/27/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP


class MZAddBestiesViewController: UIViewController {

    var addBesties = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    
    @IBOutlet weak var addBestieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        addBestieTableView.register(UINib(nibName: "MZAddBestiesTableViewCell", bundle: nil), forCellReuseIdentifier: "MZAddBestiesTableViewCell")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        Meteor.meteorClient?.addSubscription("users.besties.recommended")
        
        NotificationCenter.default.addObserver(self, selector: #selector(MZAddBestiesViewController.bestiesAdded), name: NSNotification.Name(rawValue: "besties_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZAddBestiesViewController.bestiesUpdated), name: NSNotification.Name(rawValue: "besties_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZAddBestiesViewController.bestiesRemoved), name: NSNotification.Name(rawValue: "besties_removed"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("users.besties.recommended")
        NotificationCenter.default.removeObserver(self)
    }
    
    func reload(tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
    
    
    @objc func bestiesAdded (){
        addBesties = (Meteor.meteorClient?.collections["besties"] as? M13MutableOrderedDictionary)!
        print(addBesties)
        reload(tableView: addBestieTableView)
    }
    @objc func bestiesUpdated (){
        addBesties = (Meteor.meteorClient?.collections["besties"] as? M13MutableOrderedDictionary)!
        print(addBesties)
        reload(tableView: addBestieTableView)
    }
    @objc func bestiesRemoved (){
        addBesties = (Meteor.meteorClient?.collections["besties"] as? M13MutableOrderedDictionary)!
        print(addBesties)
        reload(tableView: addBestieTableView)
    }
    
    @objc func addBestieButtonClicked (sender : UIButton){
        if Meteor.meteorClient?.connected == true{
            print(sender.accessibilityLabel)
            Meteor.meteorClient?.callMethodName("users.methods.invite-bestie", parameters: [["userId":sender.accessibilityLabel]], responseCallback: { (response, error) in
                if error != nil{
                    print(error)
                }
                else{
                    print(response)
                    sender.setTitle("Added", for: .normal)
                    sender.setTitleColor(.white, for: .normal)
                    sender.borderColor = UIColor(red: 61/255, green: 101/255, blue: 255/255, alpha: 1.0)
                    sender.backgroundColor = UIColor(red: 61/255, green: 101/255, blue: 255/255, alpha: 1.0)
                }
            })
        }
        else{
            print("not connected")
            let alert = UIAlertController(title: "Alert", message: "Check Your Connection", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

extension MZAddBestiesViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(addBesties.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addBestieTableView.dequeueReusableCell(withIdentifier: "MZAddBestiesTableViewCell") as! MZAddBestiesTableViewCell
        let current = addBesties.object(at: UInt(indexPath.row))
        let profile = current["profile"] as! [String : Any]
        cell.addUsernameLabel.text = "\(profile["firstName"] as! String) \(profile["lastName"] as! String)"
        cell.addBestieImageView.kf.indicatorType = .activity
        cell.addBestieImageView.kf.setImage(with: URL(string: profile["image"] as! String))
        cell.addBestieButton.accessibilityLabel = current["_id"] as! String
        cell.addBestieButton.addTarget(self, action: #selector(addBestieButtonClicked(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let current = addBesties.object(at: UInt(indexPath.row))
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZGUserProfileViewController") as! ZGUserProfileViewController
        vc.id = current["_id"] as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
