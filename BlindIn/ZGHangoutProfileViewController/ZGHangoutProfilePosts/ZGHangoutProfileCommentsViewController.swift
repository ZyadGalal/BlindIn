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
    var hangImage :String?
    var hangDescription : String?
    var hangLoveCount : Int?
    var hangCommentCount : Int = 0
    var userImage : String = "1"
    var postOwnerName : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.isScrollEnabled = false
        commentTextView.text = "Write a comment"
        commentTextView.textColor = UIColor.lightGray
        commentTextView.delegate = self
        sendButton.isEnabled = false

        
        Meteor.meteorClient?.addSubscription("posts.single", withParameters: [["postId":postId!]])
        NotificationCenter.default.addObserver(self, selector: #selector(getHangoutPost), name: NSNotification.Name("posts_added"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(getHangoutPost), name: NSNotification.Name("posts_changed"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(getHangoutPost), name: NSNotification.Name("posts_removed"),object : nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("posts.single")
        NotificationCenter.default.removeObserver(self)
    }

    @objc func getHangoutPost ()
    {
        print(Meteor.meteorClient?.collections)
        post = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        print(post)
        users = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
        print(users)
        if post.count > 0{
        let currentIndex = post.object(at: UInt(0))
        
        postId = currentIndex["_id"] as? String
        hangImage = currentIndex["image"] as? String
        hangDescription = currentIndex["description"] as? String
        hangLoveCount = (currentIndex["lovesCount"] as? Int)!
        hangCommentCount = (currentIndex["commentsCount"] as? Int)!
        }
        
//        let userId = comment["userId"] as? String
//        for index in 0..<users.count{
//            let user = users.object(at: UInt(index))
//            if userId == user["_id"] as? String
//            {
//                if user["image"] != nil{
//                    image = (user["image"] as? String)!
//                }
//                username = "\(user["firstName"]) \(user["lastName"])"
//                break
//            }
//
//        }
        
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
        }
}
}
extension ZGHangoutProfileCommentsViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            return hangCommentCount
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "news") as! ZGNewsFeedTableViewCell
            cell.userImageView.kf.indicatorType = .activity
            cell.userImageView.image = UIImage(named: "1")
            cell.hangImageView.kf.indicatorType = .activity
            cell.hangImageView.kf.setImage(with: URL(string: hangImage!))
            cell.userNameLable.text = "Zyad Galal"
            cell.dateLabel.text = "5 min"
            cell.likeCountLabel.text = "\(hangLoveCount!)"
            cell.commentCountLabel.text = "\(hangCommentCount)"
            cell.hangDescriptionLabel.text = hangDescription!
            return cell
        }
        else{
            let currentIndex = post.object(at: UInt(0))
            let current = currentIndex["comments"] as! [[String : Any]]
            let comment = current[indexPath.row]
            
            let userId = comment["userId"] as? String
            var image : String = "1"
            var username : String?
            for index in 0..<users.count{
                let user = users.object(at: UInt(index))
                if userId == user["_id"] as? String
                {
                    if user["image"] != nil{
                        image = (user["image"] as? String)!
                    }
                    username = "\(user["firstName"]) \(user["lastName"])"
                    break
                }
                
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "comment") as! ZGCommentsTableViewCell
            cell.userImageView.kf.setImage(with: URL(string: image))
            cell.usernameLabel.text = username!
            cell.commentLabel.text = comment["comment"] as? String
            cell.timeLabel.text = "5 am"
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
