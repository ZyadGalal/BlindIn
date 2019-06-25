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
        hangoutNotificationTableView.register(UINib(nibName: "MZHangoutAddPostTableViewCell", bundle: nil), forCellReuseIdentifier: "MZHangoutAddPostTableViewCell")
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("notifications")
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        Meteor.meteorClient?.addSubscription("notifications")
        NotificationCenter.default.addObserver(self, selector: #selector(invitesAdded), name:NSNotification.Name(rawValue: "hangout-notifications_added") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invitesUpdated), name: NSNotification.Name(rawValue: "hangout-notifications_changed") , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invitesRemoved), name: NSNotification.Name(rawValue: "hangout-notifications_removed") , object: nil)

    }
    func reload(tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
    @objc func invitesAdded (){
        print(Meteor.meteorClient?.collections)
        hangoutNotifications = (Meteor.meteorClient?.collections["invites"] as? M13MutableOrderedDictionary)!
        notificationHangout = (Meteor.meteorClient?.collections["notification-hangouts"] as? M13MutableOrderedDictionary)!
        //hangout = (Meteor.meteorClient?.collections["hangouts"] as? M13MutableOrderedDictionary)!
        print(hangoutNotifications)
        reload(tableView: hangoutNotificationTableView)
    }
    @objc func invitesUpdated (){
        hangoutNotifications = (Meteor.meteorClient?.collections["invites"] as? M13MutableOrderedDictionary)!
        notificationHangout = (Meteor.meteorClient?.collections["notification-hangouts"] as? M13MutableOrderedDictionary)!
        //hangout = (Meteor.meteorClient?.collections["hangouts"] as? M13MutableOrderedDictionary)!

        reload(tableView: hangoutNotificationTableView)
    }
    @objc func invitesRemoved (){
	        hangoutNotifications = (Meteor.meteorClient?.collections["invites"] as? M13MutableOrderedDictionary)!
        notificationHangout = (Meteor.meteorClient?.collections["notification-hangouts"] as? M13MutableOrderedDictionary)!
        //hangout = (Meteor.meteorClient?.collections["hangouts"] as? M13MutableOrderedDictionary)!

        reload(tableView: hangoutNotificationTableView)
    }
    
}


extension MZHangoutNotificationViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(hangoutNotifications.count) + Int(notificationHangout.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current = hangoutNotifications.object(at: UInt(indexPath.row))
        if current["type"] as? String == "hangout"{
            let cell = hangoutNotificationTableView.dequeueReusableCell(withIdentifier: "MZHangoutNotificationTableViewCell") as! MZHangoutNotificationTableViewCell
            cell.acceptButton.accessibilityLabel = current["_id"] as! String
            cell.acceptButton.addTarget(self, action: #selector(checkMarkButtonClicked(sender:)), for: .touchUpInside)
            if Meteor.meteorClient?.collections["hangouts"] != nil{
                hangout = (Meteor.meteorClient?.collections["hangouts"] as? M13MutableOrderedDictionary)!
                
                for i in 0..<hangout.count{
                    let hang = hangout.object(at: UInt(i))
                    if hang["_id"] as? String == current["hangoutId"] as? String{
                        cell.userNameLabel.text = hang["title"] as? String
                        break
                    }
                }
            }
            
            return cell
        }
        
        let addPostCell = hangoutNotificationTableView.dequeueReusableCell(withIdentifier: "MZHangoutAddPostTableViewCell") as! MZHangoutAddPostTableViewCell
        
//        if (cell.notificationType == Hangout invitation){}
//        cell.selectionStyle = .none
//
//        //cell.userNameLabel.text = name[indexPath.row]
//        cell.acceptButton.addTarget(self, action: #selector(checkMarkButtonClicked(sender:)), for: .touchUpInside)
//        cell.acceptButton.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
//        return cell
//        else{}
//        addPostCell.selectionStyle = .none
//        addPostCell.userNameLabel.text = name[indexPath.row]
        return addPostCell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var rejectAction = UITableViewRowAction(style: .destructive, title: "reject") { (action, indexpath) in
            if Meteor.meteorClient?.connected == true{
                let current = self.hangoutNotifications.object(at: UInt(indexPath.row))
                self.rejectInvite(id: current["_id"] as! String)
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
        
//        if sender.isSelected{
//            sender.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
//            sender.backgroundColor = UIColor.white
//            sender.isSelected = false
//        }
//        else{
//            sender.setTitle("Accepted", for: .selected)
//            sender.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
//            sender.backgroundColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
//            sender.isSelected = true
//        }
        if Meteor.meteorClient?.connected == true{
            acceptInvite(id: sender.accessibilityLabel!)
        }
        else{
            print("not connected")
        }
    }
    func acceptInvite(id : String){
        Meteor.meteorClient?.callMethodName("hangouts.methods.accept-invite", parameters: [["_id":id]], responseCallback: { (response, error) in
            if error != nil{
                print(error)
            }
            else{
                print(response)
            }
        })
    }
    func rejectInvite(id : String){
        Meteor.meteorClient?.callMethodName("hangouts.methods.reject-invite", parameters: [["_id":id]], responseCallback: { (response, error) in
            if error != nil{
                print(error)
            }
            else{
                print(response)
            }
        })
    }
    
}
