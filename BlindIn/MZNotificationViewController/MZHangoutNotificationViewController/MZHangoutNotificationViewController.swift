//
//  MZHangoutNotificationViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/15/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP

class MZHangoutNotificationViewController: UIViewController {

    @IBOutlet weak var hangoutNotificationTableView: UITableView!
    
    var notificationHangout = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var hangoutNotifications = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var hangout = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hangoutNotificationTableView.register(UINib(nibName: "MZHangoutNotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "MZHangoutNotificationTableViewCell")
        //hangoutNotificationTableView.register(UINib(nibName: "MZHangoutAddPostTableViewCell", bundle: nil), forCellReuseIdentifier: "MZHangoutAddPostTableViewCell")
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("notifications")
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        Meteor.meteorClient?.addSubscription("notifications")
        NotificationCenter.default.addObserver(self, selector: #selector(invitesAdded), name:NSNotification.Name(rawValue: "hangout-notification_added") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invitesUpdated), name: NSNotification.Name(rawValue: "hangout-notification_changed") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invitesRemoved), name: NSNotification.Name(rawValue: "hangout-notification_removed") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invitesAdded), name:NSNotification.Name(rawValue: "notification-hangouts_added") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invitesUpdated), name: NSNotification.Name(rawValue: "notification-hangouts_changed") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invitesRemoved), name: NSNotification.Name(rawValue: "notification-hangouts_removed") , object: nil)
    }
    func reload(tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
    @objc func invitesAdded (){
        //print(Meteor.meteorClient?.collections)
        if Meteor.meteorClient?.collections["hangout-notification"] != nil{
            hangoutNotifications = (Meteor.meteorClient?.collections["hangout-notification"] as? M13MutableOrderedDictionary)!
        }
        if Meteor.meteorClient?.collections["notification-hangouts"] != nil{
            notificationHangout = (Meteor.meteorClient?.collections["notification-hangouts"] as? M13MutableOrderedDictionary)!
        }
        //hangout = (Meteor.meteorClient?.collections["hangouts"] as? M13MutableOrderedDictionary)!
        reload(tableView: hangoutNotificationTableView)
    }
    @objc func invitesUpdated (){
        if Meteor.meteorClient?.collections["hangout-notification"] != nil{
            hangoutNotifications = (Meteor.meteorClient?.collections["hangout-notification"] as? M13MutableOrderedDictionary)!
        }
        if Meteor.meteorClient?.collections["notification-hangouts"] != nil{
            notificationHangout = (Meteor.meteorClient?.collections["notification-hangouts"] as? M13MutableOrderedDictionary)!
        }
        //hangout = (Meteor.meteorClient?.collections["hangouts"] as? M13MutableOrderedDictionary)!

        reload(tableView: hangoutNotificationTableView)
    }
    @objc func invitesRemoved (){
        if Meteor.meteorClient?.collections["hangout-notification"] != nil{
            hangoutNotifications = (Meteor.meteorClient?.collections["hangout-notification"] as? M13MutableOrderedDictionary)!
        }
        if Meteor.meteorClient?.collections["notification-hangouts"] != nil{
            notificationHangout = (Meteor.meteorClient?.collections["notification-hangouts"] as? M13MutableOrderedDictionary)!
        }
        //hangout = (Meteor.meteorClient?.collections["hangouts"] as? M13MutableOrderedDictionary)!

        reload(tableView: hangoutNotificationTableView)
    }
    
}
extension MZHangoutNotificationViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(hangoutNotifications.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current = hangoutNotifications.object(at: UInt(indexPath.row))

            let cell = hangoutNotificationTableView.dequeueReusableCell(withIdentifier: "MZHangoutNotificationTableViewCell") as! MZHangoutNotificationTableViewCell
        if current["type"] as? String == "hangout" || current["type"] as? String == "hangout-request"{
            cell.buttonWidthConstraints.constant = 100
            cell.acceptButton.accessibilityLabel = current["_id"] as? String
            cell.acceptButton.tag = indexPath.row
            cell.acceptButton.addTarget(self, action: #selector(checkMarkButtonClicked(sender:)), for: .touchUpInside)
            cell.notificationType.text = "Hangout Invitation"

        }
        else{
            cell.buttonWidthConstraints.constant = 0
            cell.notificationType.text = current["message"] as? String
        }
            if Meteor.meteorClient?.collections["notification-hangouts"] != nil{
                //notificationHangout = (Meteor.meteorClient?.collections["notification-hangouts"] as? M13MutableOrderedDictionary)!
                
                for i in 0..<notificationHangout.count{
                    let hang = notificationHangout.object(at: UInt(i))
                    if hang["_id"] as? String == current["hangoutId"] as? String{
                        cell.userNameLabel.text = hang["title"] as? String
                        break
                    }
                }
            }
            return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let current = hangoutNotifications.object(at: UInt(indexPath.row))
        if current["type"] as? String == "hangout" || current["type"] as? String == "hangout-request"
        {
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var rejectAction = UITableViewRowAction(style: .destructive, title: "reject") { (action, indexpath) in
            if Meteor.meteorClient?.connected == true{
                let current = self.hangoutNotifications.object(at: UInt(indexPath.row))
                if current["type"] as? String == "hangout"{
                    self.rejectInvite(id: current["_id"] as! String, method: "hangouts.methods.accept-invite")
                }
                else{
                    self.rejectInvite(id: current["_id"] as! String, method: "hangouts.methods.accept-request")
                }
            }
            else{
                print("not connected")
            }
        }
        return [rejectAction]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let current = hangoutNotifications.object(at: UInt(indexPath.row))
        let vc = UIStoryboard(name: "HangoutProfile", bundle: nil).instantiateViewController(withIdentifier: "ZGHangoutProfileViewController") as! ZGHangoutProfileViewController
        vc.hangoutId = current["hangoutId"] as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func checkMarkButtonClicked (sender : UIButton){
        if Meteor.meteorClient?.connected == true{
            let current = hangoutNotifications.object(at: UInt(sender.tag))
            if current["type"] as? String == "hangout"{
                acceptInvite(id: sender.accessibilityLabel!, method: "hangouts.methods.accept-invite")
            }
            else{
                acceptInvite(id: sender.accessibilityLabel!, method: "hangouts.methods.accept-request")
            }
        }
        else{
            print("not connected")
        }
    }
    func acceptInvite(id : String , method : String){
        Meteor.meteorClient?.callMethodName(method, parameters: [["_id":id]], responseCallback: { (response, error) in
            if error != nil{
                print(error)
            }
            else{
                print(response)
            }
        })
    }
    func rejectInvite(id : String , method : String){
        Meteor.meteorClient?.callMethodName(method, parameters: [["_id":id]], responseCallback: { (response, error) in
            if error != nil{
                print(error)
            }
            else{
                print(response)
            }
        })
    }
    
}
