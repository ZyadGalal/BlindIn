//
//  ZGHangoutProfilePostsViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/17/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP
import Kingfisher

class ZGHangoutProfilePostsViewController: UIViewController {

    @IBOutlet weak var hangoutPostsTableView: UITableView!
    
    var postsList = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var usersList = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var hangoutId = "agKkwBDSZc6okbt8M"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hangout Posts"
        let addNewPostButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPostButtonClicked))
        self.navigationItem.rightBarButtonItem = addNewPostButton
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        Meteor.meteorClient?.addSubscription("hangouts.posts.all", withParameters: [hangoutId])
        NotificationCenter.default.addObserver(self, selector: #selector(getAllHangoutPosts), name: NSNotification.Name("posts_added"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(getAllHangoutPosts), name: NSNotification.Name("posts_changed"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(getAllHangoutPosts), name: NSNotification.Name("posts_removed"),object : nil)
    }


    @IBAction func likeButtonClicked(_ sender: UIButton) {
        let currentIndex = postsList.object(at: UInt(sender.tag))
        loveMethodConnection(postId: (currentIndex["_id"] as? String)!)
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
    @objc func getAllHangoutPosts ()
    {
        postsList = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        print(postsList)
        hangoutPostsTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("hangouts.posts.all")
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
        let currentIndex = postsList.object(at: UInt(indexPath.row))
        let cell = tableView.dequeueReusableCell(withIdentifier: "news") as! ZGNewsFeedTableViewCell
        cell.userImageView.kf.indicatorType = .activity
        cell.userImageView.image = UIImage(named: "1")
        cell.hangImageView.kf.indicatorType = .activity
        cell.hangImageView.kf.setImage(with: URL(string: currentIndex["image"] as! String))
        cell.userNameLable.text = "Zyad Galal"
        cell.dateLabel.text = "5 min"
        cell.likeCountLabel.text = "\((currentIndex["lovesCount"] as? Int)!)"
        cell.commentCountLabel.text = "\((currentIndex["commentsCount"] as? Int)!)"
        cell.hangDescriptionLabel.text = currentIndex["description"] as? String
        cell.likeButton.tag = indexPath.row
        return cell
    }
}
extension ZGHangoutProfilePostsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentIndex = postsList.object(at: UInt(indexPath.row))
        let vc = UIStoryboard(name: "HangoutProfile", bundle: nil).instantiateViewController(withIdentifier: "ZGHangoutProfileCommentsViewController") as! ZGHangoutProfileCommentsViewController
        vc.postId = currentIndex["_id"] as? String
        vc.hangImage = currentIndex["image"] as? String
        vc.hangDescription = currentIndex["description"] as? String
        vc.hangLoveCount = (currentIndex["lovesCount"] as? Int)!
        //vc.hangCommentCount = (currentIndex["commentsCount"] as? Int)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
