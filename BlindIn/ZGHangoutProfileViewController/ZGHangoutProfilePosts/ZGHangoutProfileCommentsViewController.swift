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
    var hangImage : String?
    var hangDescription : String?
    var hangLoveCount : Int?
    var hangCommentCount : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.isScrollEnabled = false
        commentTextView.text = "Write a comment"
        commentTextView.textColor = UIColor.lightGray
        commentTextView.delegate = self
        sendButton.isEnabled = false

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
            return 20
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
            cell.commentCountLabel.text = "\(hangCommentCount!)"
            cell.hangDescriptionLabel.text = hangDescription!
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "comment") as! ZGCommentsTableViewCell
            cell.userImageView.image = UIImage(named: "1")
            cell.usernameLabel.text = "Zyad Galal"
            cell.commentLabel.text = "i am very happy to interact with this awesome iOS design"
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
