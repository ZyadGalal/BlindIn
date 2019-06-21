//
//  ZGHangoutProfileCommentsViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/20/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class ZGHangoutProfileCommentsViewController: UIViewController {

    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentsTableView: UITableView!
    
    var postId : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.isScrollEnabled = false
        commentTextView.text = "Write a comment"
        commentTextView.textColor = UIColor.lightGray
        commentTextView.delegate = self
    }
  
    @IBAction func sendButtonClicked(_ sender: Any) {
        if Meteor.meteorClient?.connected == true{
            Meteor.meteorClient?.callMethodName("posts.methods.comment", parameters: [["_id":postId!,"comment":commentTextView.text!]], responseCallback: { (response, error) in
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
}
extension ZGHangoutProfileCommentsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "news") as! ZGNewsFeedTableViewCell
            cell.userImageView.image = UIImage(named: "1")
            cell.userNameLable.text = "Zyad Galal"
            cell.dateLabel.text = "5 min"
            cell.hangImageView.image = UIImage(named: "1")
            cell.likeCountLabel.text = "55555"
            cell.commentCountLabel.text = "10"
            cell.hangDescriptionLabel.text = "hi , i'm zyad mahmoud galal , i'm iOS Developer , from new damietta . in mansoura university"
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
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a comment"
            textView.textColor = UIColor.lightGray
        }
    }
}
