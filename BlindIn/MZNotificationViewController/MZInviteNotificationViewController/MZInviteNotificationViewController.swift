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
    
    var notifications = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var users = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        inviteTabelView.register(UINib(nibName: "MZFollowBackTableViewCell", bundle: nil), forCellReuseIdentifier: "MZFollowBackTableViewCell")
//        inviteTabelView.register(UINib(nibName: "MZBestieTableViewCell", bundle: nil), forCellReuseIdentifier: "MZBestieTableViewCell")

        inviteTabelView.register(UINib(nibName: "MZHangoutNotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "MZHangoutNotificationTableViewCell")
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("notifications")
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        Meteor.meteorClient?.addSubscription("notifications")
        NotificationCenter.default.addObserver(self, selector: #selector(invitesAdded), name:NSNotification.Name(rawValue: "invite-notification_added") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invitesUpdated), name: NSNotification.Name(rawValue: "invite-notification_changed") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invitesRemoved), name: NSNotification.Name(rawValue: "invite-notification_removed") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invitesAdded), name:NSNotification.Name(rawValue: "notification-users_added") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invitesUpdated), name: NSNotification.Name(rawValue: "notification-users_changed") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invitesRemoved), name: NSNotification.Name(rawValue: "notification-users_removed") , object: nil)
    }
    func reload(tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
    @objc func invitesAdded (){
        if Meteor.meteorClient?.collections["invite-notification"] != nil{
            notifications = (Meteor.meteorClient?.collections["invite-notification"] as? M13MutableOrderedDictionary)!
            if Meteor.meteorClient?.collections["notification-users"] != nil{
                users = (Meteor.meteorClient?.collections["notification-users"] as? M13MutableOrderedDictionary)!
                reload(tableView: inviteTabelView)
            }
        }
    }
    @objc func invitesUpdated (){
        if Meteor.meteorClient?.collections["invite-notification"] != nil{
            notifications = (Meteor.meteorClient?.collections["invite-notification"] as? M13MutableOrderedDictionary)!
            users = (Meteor.meteorClient?.collections["notification-users"] as? M13MutableOrderedDictionary)!
            reload(tableView: inviteTabelView)
        }
    }
    @objc func invitesRemoved (){
        if Meteor.meteorClient?.collections["invite-notification"] != nil{
            notifications = (Meteor.meteorClient?.collections["invite-notification"] as? M13MutableOrderedDictionary)!
            users = (Meteor.meteorClient?.collections["notification-users"] as? M13MutableOrderedDictionary)!
            reload(tableView: inviteTabelView)
        }
    }
    func followBack(userId : String){
        Meteor.meteorClient?.callMethodName("users.methods.follow", parameters: [["userId":userId]], responseCallback: { (response, error) in
            if error != nil{
                print(error)
            }
            else{
                print(response)
            }
        })
    }
    func acceptBestie(id : String){
        Meteor.meteorClient?.callMethodName("users.methods.accept-bestie", parameters: [["_id":id]], responseCallback: { (response, error) in
            if error != nil{
                print(error)
            }
            else{
                print(response)
            }
        })
    }
    func rejectBestie(id : String){
        Meteor.meteorClient?.callMethodName("users.methods.reject-besite", parameters: [["_id":id]], responseCallback: { (response, error) in
            if error != nil{
                print(error)
            }
            else{
                print(response)
            }
        })
    }
}

extension MZInviteNotificationViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(notifications.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current = notifications.object(at: UInt(indexPath.row))
        let followCell = tableView.dequeueReusableCell(withIdentifier: "MZHangoutNotificationTableViewCell") as! MZHangoutNotificationTableViewCell
        followCell.acceptButton.tag = indexPath.row
        if current["type"] as? String == "bestie"{
            followCell.acceptButton.setTitle("Accept", for: .normal)
            followCell.buttonWidthConstraints.constant = 110
            followCell.acceptButton.addTarget(self, action: #selector(FollowBackButtonClicked(sender:)), for: .touchUpInside)
        }
        else if current["type"] as? String == "follow"{
            followCell.acceptButton.setTitle("Follow Back", for: .normal)
            followCell.buttonWidthConstraints.constant = 110
            followCell.acceptButton.addTarget(self, action: #selector(FollowBackButtonClicked(sender:)), for: .touchUpInside)
        }
        else if current["type"] as? String == "invite-notification"{
            followCell.buttonWidthConstraints.constant = 0
        }
        if Meteor.meteorClient?.collections["notification-users"] != nil{
            //notificationHangout = (Meteor.meteorClient?.collections["notification-hangouts"] as? M13MutableOrderedDictionary)!
            
            for i in 0..<users.count{
                let user = users.object(at: UInt(i))
                if user["_id"] as? String == current["senderId"] as? String{
                    let profile = user["profile"] as! [String:Any]
                    followCell.userNameLabel.text = "\(profile["firstName"] as! String) \(profile["lastName"] as! String)"
                    break
                }
            }
        }
        followCell.notificationType.text = current["message"] as? String
        return followCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let current = notifications.object(at: UInt(indexPath.row))
        if current["type"] as? String == "bestie"
        {
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var rejectAction = UITableViewRowAction(style: .destructive, title: "reject") { (action, indexpath) in
            if Meteor.meteorClient?.connected == true{
                let current = self.notifications.object(at: UInt(indexPath.row))
                self.rejectBestie(id: current["_id"] as! String)
            }
            else{
                print("not connected")
            }
        }
        return [rejectAction]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let current = notifications.object(at: UInt(indexPath.row))
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZGUserProfileViewController") as! ZGUserProfileViewController
        vc.id = current["senderId"] as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func FollowBackButtonClicked (sender : UIButton){
        let current = notifications.object(at: UInt(sender.tag))
        if current["type"] as? String == "bestie"{
            self.acceptBestie(id: current["_id"] as! String)
        }
        else if current["type"] as? String == "follow"{
            self.followBack(userId: current["userId"] as! String)
        }
    }
}
