//
//  MZInviteNotificationViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/15/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP
class MZInviteNotificationViewController: UIViewController {

    @IBOutlet weak var inviteTabelView: UITableView!
    
    var name = ["Momen","Momen Adel","Momen Adel Mohamed","Mo2a","El Mo2"]
    var notifications = M13MutableOrderedDictionary<NSCopying, AnyObject>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        inviteTabelView.register(UINib(nibName: "MZFollowBackTableViewCell", bundle: nil), forCellReuseIdentifier: "MZFollowBackTableViewCell")
        inviteTabelView.register(UINib(nibName: "MZBestieTableViewCell", bundle: nil), forCellReuseIdentifier: "MZBestieTableViewCell")

    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("invites-notifications")
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        Meteor.meteorClient?.addSubscription("invites-notifications")
        NotificationCenter.default.addObserver(self, selector: #selector(invitesAdded), name:NSNotification.Name(rawValue: "invites_added") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invitesUpdated), name: NSNotification.Name(rawValue: "invites_changed") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invitesRemoved), name: NSNotification.Name(rawValue: "invites_removed") , object: nil)
    }
    func reload(tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
    @objc func invitesAdded (){
        notifications = (Meteor.meteorClient?.collections["invites"] as? M13MutableOrderedDictionary)!
        print(notifications)
        reload(tableView: inviteTabelView)
    }
    @objc func invitesUpdated (){
        notifications = (Meteor.meteorClient?.collections["invites"] as? M13MutableOrderedDictionary)!
        reload(tableView: inviteTabelView)
    }
    @objc func invitesRemoved (){
        notifications = (Meteor.meteorClient?.collections["invited"] as? M13MutableOrderedDictionary)!
        reload(tableView: inviteTabelView)
    }

}

extension MZInviteNotificationViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let followCell = inviteTabelView.dequeueReusableCell(withIdentifier: "MZFollowBackTableViewCell") as! MZFollowBackTableViewCell
        //let bestieBackCell = inviteTabelView.dequeueReusableCell(withIdentifier: "MZConfirmBestieTableViewCell") as! MZConfirmBestieTableViewCell
        
        //        if (cellType == Follow){}
        followCell.selectionStyle = .none
        followCell.followerNameLabel.text = name[indexPath.row]
        followCell.followBackButton.addTarget(self, action: #selector(FollowBackButtonClicked(sender:)), for: .touchUpInside)
        followCell.followBackButton.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
        return followCell
        //        else{}
        //        bestieBackCell.selectionStyle = .none
        //        bestieBackCell.bestieNameLabel.text = name[indexPath.row]
        //        bestieBackCell.confirmBestieButton.addTarget(self, action: #selector(ConfirmBestieButtonClicked(sender:)), for: .touchUpInside)
        //        bestieBackCell.confirmBestieButton.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
        //        return bestieNameLabel
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            name.remove(at: indexPath.row)
            inviteTabelView.reloadData()
        }
    }
    
    
    @objc func FollowBackButtonClicked (sender : UIButton){
        print("Button Clicked")
        if sender.isSelected{
            sender.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
            sender.backgroundColor = UIColor.white
            sender.isSelected = false
        }
        else{
            sender.setTitle("Following", for: .selected)
            sender.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
            sender.backgroundColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
            sender.isSelected = true
        }
    }
    
    @objc func ConfirmBestieButtonClicked (sender : UIButton){
        print("Button Clicked")
        if sender.isSelected{
            sender.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
            sender.isSelected = false
        }
        else{
            sender.setTitle("Confirmed", for: .selected)
            sender.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
            sender.backgroundColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
            sender.isSelected = true
        }
    }
}
