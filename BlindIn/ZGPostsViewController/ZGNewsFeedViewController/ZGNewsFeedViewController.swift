//
//  ZGNewsFeedViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/4/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP
import Kingfisher

class ZGNewsFeedViewController: UIViewController {

    @IBOutlet weak var newsFeedTableView: UITableView!
    var postsList = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var usersList = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    override func viewDidLoad() {
        super.viewDidLoad()
        //putProfileBtnInNavigationController()
    }
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        let currentIndex = postsList.object(at: UInt(sender.tag))
        loveMethodConnection(postId: (currentIndex["_id"] as? String)!)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        Meteor.meteorClient?.addSubscription("posts.newsfeed")
        NotificationCenter.default.addObserver(self, selector: #selector(getAllHangoutPosts), name: NSNotification.Name("posts_added"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(updateAllHangoutPosts), name: NSNotification.Name("posts_changed"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(removeAllHangoutPosts), name: NSNotification.Name("posts_removed"),object : nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("posts.newsfeed")
        NotificationCenter.default.removeObserver(self)
    }
    func reload(tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
//    func putProfileBtnInNavigationController ()
//    {
//        let profileButton : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        profileButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        profileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        profileButton.layer.masksToBounds = true
//        profileButton.layer.cornerRadius = 20
//        profileButton.setImage(UIImage(named: "1"), for: .normal)
//        profileButton.imageView?.contentMode = .scaleToFill
//        profileButton.addTarget(self, action: #selector(ProfileButtonClicked), for: .touchUpInside)
//        let navigationBtn = UIBarButtonItem(customView: profileButton)
//        self.navigationItem.setRightBarButton(navigationBtn, animated: false)
//
//
//    }
//    @objc func ProfileButtonClicked ()
//    {
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZGUserProfileViewController") as! ZGUserProfileViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
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
        usersList = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
        reload(tableView: newsFeedTableView)
    }
    @objc func updateAllHangoutPosts ()
    {
        postsList = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        print(postsList)
        usersList = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
        reload(tableView: newsFeedTableView)
    }
    @objc func removeAllHangoutPosts ()
    {
        postsList = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        print(postsList)
        usersList = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
        reload(tableView: newsFeedTableView)
    }
}
extension ZGNewsFeedViewController : UITableViewDataSource{
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
        
        cell.dateLabel.text = "5 min"
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
extension ZGNewsFeedViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentIndex = postsList.object(at: UInt(indexPath.row))

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZGPostsDetailsViewController") as! ZGPostsDetailsViewController
        vc.postId = currentIndex["_id"] as? String
        //vc.indexClicked = indexPath.row

        self.navigationController?.pushViewController(vc, animated: true)
    }
}
