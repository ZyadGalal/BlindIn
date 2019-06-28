//
//  ZGInviteBestiesViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/28/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP
import Kingfisher
class ZGInviteBestiesViewController: UIViewController {

    @IBOutlet weak var bestieTableView: UITableView!
    var besties = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var hangoutId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        bestieTableView.register(UINib(nibName: "MZAddBestiesTableViewCell", bundle: nil), forCellReuseIdentifier: "MZAddBestiesTableViewCell")
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    @objc func addBestieButton(sender : UIButton){
        Meteor.meteorClient?.callMethodName("hangouts.methods.invite", parameters: [["hangoutId" : hangoutId,"userId" : sender.accessibilityLabel!]], responseCallback: { (response, error) in
            if error != nil{
                print(error)
            }
            else{
                print(response)
            }
        })
    }
}
extension ZGInviteBestiesViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(besties.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bestieTableView.dequeueReusableCell(withIdentifier: "MZAddBestiesTableViewCell") as! MZAddBestiesTableViewCell
        let current = besties.object(at: UInt(indexPath.row))
        let profile = current["profile"] as! [String : Any]
        cell.addUsernameLabel.text = "\(profile["firstName"] as! String) \(profile["lastName"] as! String)"
        cell.addBestieImageView.kf.indicatorType = .activity
        cell.addBestieImageView.kf.setImage(with: URL(string: profile["image"] as! String))
        cell.addBestieButton.accessibilityLabel = current["_id"] as? String
        cell.addBestieButton.addTarget(self, action: #selector(addBestieButton(sender:)), for: .touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let current = besties.object(at: UInt(indexPath.row))
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZGUserProfileViewController") as! ZGUserProfileViewController
        vc.id = current["_id"] as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
