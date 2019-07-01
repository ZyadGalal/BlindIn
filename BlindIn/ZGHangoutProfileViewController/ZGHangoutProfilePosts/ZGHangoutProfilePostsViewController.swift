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
    var hangoutId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hangout Posts"
        let addNewPostButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPostButtonClicked))
        self.navigationItem.rightBarButtonItem = addNewPostButton
        
        
    }
 
    override func viewDidAppear(_ animated: Bool) {
        Meteor.meteorClient?.addSubscription("hangouts.posts.all", withParameters: [["hangoutId" : hangoutId]])
        NotificationCenter.default.addObserver(self, selector: #selector(getAllHangoutPosts), name: NSNotification.Name("posts_added"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(updateAllHangoutPosts), name: NSNotification.Name("posts_changed"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(removeAllHangoutPosts), name: NSNotification.Name("posts_removed"),object : nil)
        if Meteor.meteorClient?.collections["posts"] != nil{
            postsList = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
            reload(tableView: hangoutPostsTableView)
        }
    }
    func reload(tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
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
            let alert = UIAlertController(title: "Alert", message: "Check Your Connection", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @objc func getAllHangoutPosts ()
    {
        if postsList.count != 0{
            postsList = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
            print(postsList)
            usersList = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
            reload(tableView: hangoutPostsTableView)
        }
    }
    @objc func updateAllHangoutPosts ()
    {
        if postsList.count != 0{
            postsList = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
            print(postsList)
            usersList = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
            reload(tableView: hangoutPostsTableView)
        }
    }
    @objc func removeAllHangoutPosts ()
    {
        if postsList.count != 0{
            postsList = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
            print(postsList)
            usersList = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
            reload(tableView: hangoutPostsTableView)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("hangouts.posts.all")
        NotificationCenter.default.removeObserver(self)
        //postsList.removeAllObjects()
    }
    @objc func addNewPostButtonClicked (){
        let vc = UIStoryboard(name: "HangoutProfile", bundle: nil).instantiateViewController(withIdentifier: "ZGAddNewPostViewController") as! ZGAddNewPostViewController
        vc.hangoutId = self.hangoutId
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
        
        cell.hangImageView.kf.indicatorType = .activity
        cell.hangImageView.kf.setImage(with: URL(string: currentIndex["image"] as! String))
        for index in 0..<usersList.count {
            let currentpost = postsList.object(at: UInt(indexPath.row))
            let currentuser = usersList.object(at: UInt(index))
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
}
extension ZGHangoutProfilePostsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentIndex = postsList.object(at: UInt(indexPath.row))

        let vc = UIStoryboard(name: "HangoutProfile", bundle: nil).instantiateViewController(withIdentifier: "ZGHangoutProfileCommentsViewController") as! ZGHangoutProfileCommentsViewController
        vc.postId = currentIndex["_id"] as? String
        //vc.indexClicked = indexPath.row

        self.navigationController?.pushViewController(vc, animated: true)
    }
}
