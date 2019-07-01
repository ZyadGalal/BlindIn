//
//  ZGHangoutProfileCommentsViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/20/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP
import Kingfisher

class ZGHangoutProfileCommentsViewController: UIViewController {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentsTableView: UITableView!
    
    var postId : String?
    var post = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var users = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    //var indexClicked : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.isScrollEnabled = false
        commentTextView.text = "Write a comment"
        commentTextView.textColor = UIColor.lightGray
        commentTextView.delegate = self
        sendButton.isEnabled = false

        
    }
    override func viewDidAppear(_ animated: Bool) {
        Meteor.meteorClient?.addSubscription("posts.single", withParameters: [["postId":postId!]])
        NotificationCenter.default.addObserver(self, selector: #selector(getHangoutPost), name: NSNotification.Name("posts_added"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(updateHangoutPost), name: NSNotification.Name("posts_changed"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(removeHangoutPost), name: NSNotification.Name("posts_removed"),object : nil)


    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("posts.single")
        NotificationCenter.default.removeObserver(self)
    }
    @objc func updateHangoutPost ()
    {
        print(Meteor.meteorClient?.collections)
        post = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        print(post)
        users = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
        print(users)

        commentsTableView.reloadData()
    }
    @objc func getHangoutPost ()
    {
        print(Meteor.meteorClient?.collections)
        post = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        print(post)
        users = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
        print(users)

        commentsTableView.reloadData()
    }
    @objc func removeHangoutPost ()
    {
        post = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        print(post)
        users = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
        print(users)
        
        commentsTableView.reloadData()
    }
    @IBAction func likeButtonClicked(_ sender: UIButton) {
       
        loveMethodConnection(postId: (postId)!)
    }
    func loveMethodConnection (postId : String){
        if Meteor.meteorClient?.connected == true{
            Meteor.meteorClient?.callMethodName("posts.methods.love", parameters: [["_id":postId]], responseCallback: { (response, error) in
                if error != nil{
                    print(error!)
                }
                else{
                    print(response!)
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
    @IBAction func sendButtonClicked(_ sender: Any) {
        if Meteor.meteorClient?.connected == true{
            Meteor.meteorClient?.callMethodName("posts.methods.comment", parameters: [["_id":postId!,"comment":commentTextView.text!]], responseCallback: { (response, error) in
                if error != nil{
                    print(error!)
                }
                else{
                    print(response!)
                    self.commentTextView.text = ""
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
extension ZGHangoutProfileCommentsViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return post.count == 0 ? 0 : 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return  1
        }
        else{
            let currentIndex = post.object(at: UInt(0))
            let current = currentIndex["comments"] as! [[String : Any]]
            return current.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            
            let currentIndex = post.object(at: UInt(0))
            let cell = tableView.dequeueReusableCell(withIdentifier: "news") as! ZGNewsFeedTableViewCell
            
            cell.hangImageView.kf.indicatorType = .activity
            cell.hangImageView.kf.setImage(with: URL(string: currentIndex["image"] as! String))
            for index in 0..<users.count {
                let currentpost = post.object(at: UInt(indexPath.row))
                let currentuser = users.object(at: UInt(index))
                if currentpost["userId"] as? String == currentuser["_id"] as? String{
                    let userProfile = currentuser["profile"] as! [String:Any]
                    cell.userNameLable.text = "\(userProfile["firstName"] as! String) \(userProfile["lastName"] as! String)"
                    cell.userImageView.kf.setImage(with: URL(string: userProfile["image"] as! String))
                }
            }
            
            cell.dateLabel.text = currentIndex["time"] as? String
            cell.likeCountLabel.text = "\((currentIndex["lovesCount"] as? Int)!)"
            cell.commentCountLabel.text = "\((currentIndex["commentsCount"] as? Int)!)"
            cell.hangDescriptionLabel.text = currentIndex["description"] as? String
            cell.likeButton.tag = indexPath.row
            let loveArray = currentIndex["loves"] as? [String]
            if (loveArray?.contains((Meteor.meteorClient?.userId)!)) == true{
                cell.likeButton.setImage(UIImage(named:"like"), for: .normal)
            }
            else{
                cell.likeButton.setImage(UIImage(named:"unlike"), for: .normal)
            }
            return cell
        }
        else{
            let currentIndex = post.object(at: UInt(0))
            let current = currentIndex["comments"] as! [[String : Any]]
            let comment = current[indexPath.row]
            
            let userId = comment["userId"] as? String
            var image : String = "1"
            var username : String = "zz"
            for index in 0..<users.count{
                let user = users.object(at: UInt(index))
                if userId == user["_id"] as? String
                {
                    let userProfile = user["profile"] as? [String: Any]
                    image = (userProfile!["image"] as? String)!
                    
                    username = "\(userProfile!["firstName"] as! String) \(userProfile!["lastName"] as! String)"
                    break
                }
                
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "comment") as! ZGCommentsTableViewCell
            cell.userImageView.kf.setImage(with: URL(string: image))
            cell.usernameLabel.text = username
            cell.commentLabel.text = comment["comment"] as? String
            cell.timeLabel.text = currentIndex["time"] as? String
            return cell
        }
    }
}

extension ZGHangoutProfileCommentsViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
            sendButton.isEnabled = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a comment"
            textView.textColor = UIColor.lightGray
            sendButton.isEnabled = false
        }
    }
}
