//
//  ZGHangoutProfilePostsViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/17/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class ZGHangoutProfilePostsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hangout Posts"
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }


}
extension ZGHangoutProfilePostsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}
