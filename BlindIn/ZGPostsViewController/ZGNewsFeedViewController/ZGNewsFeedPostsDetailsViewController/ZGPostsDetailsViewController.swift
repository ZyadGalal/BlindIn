//
//  ZGPostsDetailsViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/18/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class ZGPostsDetailsViewController: UIViewController {

    @IBOutlet weak var commentTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        commentTextView.isScrollEnabled = false
        commentTextView.text = "Write a comment"
        commentTextView.textColor = UIColor.lightGray
        commentTextView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
extension ZGPostsDetailsViewController : UITableViewDataSource{
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
extension ZGPostsDetailsViewController : UITextViewDelegate{
    
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
