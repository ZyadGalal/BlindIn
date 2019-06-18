//
//  ZGHangoutProfileChatViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/17/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class ZGHangoutProfileChatViewController: UIViewController {

    
    
    @IBOutlet weak var inputMessageTextView: UITextView!
    let meesages = ["label","ZGHangoutProfileChatViewControllerZGHangoutProfileChatViewControllerZGHangoutProfileChatViewController","ZGHangoutProfileChatViewController","ZGHangoutProfileChatViewControllerZGHangoutProfileChatViewControllerZGHangoutProfileChatViewControllerZGHangoutProfileChatViewControllerZGHangoutProfileChatViewControllerZGHangoutProfileChatViewControllerZGHangoutProfileChatViewController","ZGHangoutProfileChatViewController","ZGHangoutProfileChatViewControllerZGHangoutProfileChatViewControllerZGHangoutProfileChatViewControllerZGHangoutProfileChatViewControllerZGHangoutProfileChatViewController","ZGHangoutProfileChatViewController"]
    var flag = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hangout Chat"
        inputMessageTextView.isScrollEnabled = false
        inputMessageTextView.text = "Write a Message"
        inputMessageTextView.textColor = UIColor.lightGray
        inputMessageTextView.delegate = self
//        let amountOfLinesToBeShown: CGFloat = 6
//        var maxHeight: CGFloat = inputMessageTextView.font!.lineHeight * amountOfLinesToBeShown
//        inputMessageTextView.sizeThatFits(CGSize(width: inputMessageTextView.frame.width, height: maxHeight))

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    

}
extension ZGHangoutProfileChatViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meesages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if flag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "my") as! MyMessagesTableViewCell
            cell.dateLabel.text = "3:45 AM"
            cell.myMessageLabel.text = meesages[indexPath.row]
            flag = 2
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "other") as! OtherMessagesTableViewCell
            cell.dateLabel.text = "4:45 PM"
            cell.userMessageLabel.text = meesages[indexPath.row]
            cell.usernameLabel.text = "Zyad Galal"
            cell.userImageView.image = UIImage(named: "1")
            flag = 1
            return cell
        }
    }
}

extension ZGHangoutProfileChatViewController : UITextViewDelegate{

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write Message"
            textView.textColor = UIColor.lightGray
        }
    }
}
