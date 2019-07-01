//
//  ZGHangoutProfileChatViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/17/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP

class ZGHangoutProfileChatViewController: UIViewController {

    
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var inputMessageTextView: UITextView!
    
    
    var hangoutId = ""
    var chatList = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var usersList = M13MutableOrderedDictionary<NSCopying, AnyObject>()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hangout Chat"
        inputMessageTextView.isScrollEnabled = false
        inputMessageTextView.text = "Write a Message"
        inputMessageTextView.textColor = UIColor.lightGray
        inputMessageTextView.delegate = self
        
        sendButton.isEnabled = false
//        let amountOfLinesToBeShown: CGFloat = 6
//        var maxHeight: CGFloat = inputMessageTextView.font!.lineHeight * amountOfLinesToBeShown
//        inputMessageTextView.sizeThatFits(CGSize(width: inputMessageTextView.frame.width, height: maxHeight))

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        Meteor.meteorClient?.addSubscription("hangouts.chat", withParameters: [["hangoutId":hangoutId]])
        NotificationCenter.default.addObserver(self, selector: #selector(getAllHangoutChat), name: NSNotification.Name("chat_added"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(updateAllHangoutChat), name: NSNotification.Name("chat_changed"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(removeHangoutChat), name: NSNotification.Name("chat_removed"),object : nil)
    }
    func reload(tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
    @objc func getAllHangoutChat ()
    {
        chatList = Meteor.meteorClient?.collections["chat"] as! M13MutableOrderedDictionary
        print(chatList)
        usersList = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
        print(usersList)
        reload(tableView: chatTableView)
        let indexPath = IndexPath(row: Int(self.chatList.count)-1, section: 0)
        self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    @objc func updateAllHangoutChat ()
    {
        chatList = Meteor.meteorClient?.collections["chat"] as! M13MutableOrderedDictionary
        print(chatList)
        usersList = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
        print(usersList)
        reload(tableView: chatTableView)
        let indexPath = IndexPath(row: Int(self.chatList.count)-1, section: 0)
        self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    @objc func removeHangoutChat ()
    {
        chatList = Meteor.meteorClient?.collections["chat"] as! M13MutableOrderedDictionary
        print(chatList)
        usersList = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
        print(usersList)
        reload(tableView: chatTableView)
        let indexPath = IndexPath(row: Int(self.chatList.count)-1, section: 0)
        self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("hangouts.chat")
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        if Meteor.meteorClient?.connected == true{
            sendNewMessage(hangoutId: hangoutId, message: inputMessageTextView.text!)
        }
        else{
            print("not connected")
        }
    }
    func sendNewMessage (hangoutId : String , message : String){
        Meteor.meteorClient?.callMethodName("hangouts.methods.message", parameters: [["hangoutId" : hangoutId,"message" : message ]], responseCallback: { (response, error) in
            if error != nil{
                print(error)
            }
            else{
                print(response)
                self.inputMessageTextView.text = ""
            }
        })
    }
}
extension ZGHangoutProfileChatViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(chatList.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentIndex = chatList.object(at: UInt(indexPath.row))
        if currentIndex["userId"] as? String == Meteor.meteorClient?.userId  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "my") as! MyMessagesTableViewCell
            cell.dateLabel.text = currentIndex["time"] as? String
            cell.myMessageLabel.text = currentIndex["message"] as? String
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "other") as! OtherMessagesTableViewCell
            cell.dateLabel.text = currentIndex["time"] as? String
            cell.userMessageLabel.text = currentIndex["message"] as? String
            
            for index in 0..<usersList.count{
                let user = usersList.object(at: UInt(index))
                if currentIndex["userId"] as? String == user["_id"] as? String{
                    let currentUser = user["profile"] as? [String:Any]
                    cell.usernameLabel.text = "\(currentUser!["firstName"] as! String) \(currentUser!["lastName"] as! String)"
                    cell.userImageView.kf.setImage(with: URL(string: (currentUser!["image"] as? String)!))
                    break
                }
            }
            
            return cell
        }
    }
}

extension ZGHangoutProfileChatViewController : UITextViewDelegate{

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
            sendButton.isEnabled = true
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write Message"
            textView.textColor = UIColor.lightGray
            sendButton.isEnabled = false

        }
    }
}
