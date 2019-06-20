//
//  ZGHangoutProfilePostsViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/17/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP

class ZGHangoutProfilePostsViewController: UIViewController {

    @IBOutlet weak var hangoutPostsTableView: UITableView!
    
    var postsList = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hangout Posts"
        let _ = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPostButtonClicked))
        Meteor.meteorClient?.addSubscription("hangouts.posts.all", withParameters: [["hangoutId" : " "]])
        NotificationCenter.default.addObserver(self, selector: #selector(getAllHangoutPosts), name: NSNotification.Name("hangouts.posts_added"),object : nil)
         NotificationCenter.default.addObserver(self, selector:  #selector(getAllHangoutPosts), name: NSNotification.Name("hangouts.posts_changed"),object : nil)
         NotificationCenter.default.addObserver(self, selector:  #selector(getAllHangoutPosts), name: NSNotification.Name("hangouts.posts_removed"),object : nil)
    }
    @objc func getAllHangoutPosts ()
    {
        postsList = Meteor.meteorClient?.collections["hangout.posts"] as! M13MutableOrderedDictionary
        hangoutPostsTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("interests.all")
        NotificationCenter.default.removeObserver(self)
        postsList.removeAllObjects()
    }
    @objc func addNewPostButtonClicked (){
        let vc = UIStoryboard(name: "HangoutProfile", bundle: nil).instantiateViewController(withIdentifier: "ZGAddNewPostViewController") as! ZGAddNewPostViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension ZGHangoutProfilePostsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(postsList.count)
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
