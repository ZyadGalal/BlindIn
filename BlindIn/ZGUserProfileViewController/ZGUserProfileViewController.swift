//
//  ZGUserProfileViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/5/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP
import Kingfisher

class ZGUserProfileViewController: UIViewController {
    
    var interestLists = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var postsList = M13MutableOrderedDictionary<NSCopying, AnyObject>()

    @IBOutlet weak var profileTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fadeAnimationForNavigationTitle()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var id : String = Meteor.meteorClient!.userId
        print(id)
        Meteor.meteorClient?.addSubscription("users.profile", withParameters: [["userId":id]] )
        //---------------------------
        NotificationCenter.default.addObserver(self, selector: #selector(ZGUserProfileViewController.getAllInterests), name: NSNotification.Name(rawValue: "interests_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ZGUserProfileViewController.getAllInterests), name: NSNotification.Name(rawValue: "interests_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ZGUserProfileViewController.getAllInterests), name: NSNotification.Name(rawValue: "interests_removed"), object: nil)
        //---------------------------------------------------------
        NotificationCenter.default.addObserver(self, selector: #selector(ZGUserProfileViewController.getAllHangoutPosts), name: NSNotification.Name(rawValue: "posts_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ZGUserProfileViewController.updateAllHangoutPosts), name: NSNotification.Name(rawValue: "posts_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ZGUserProfileViewController.removeAllHangoutPosts), name: NSNotification.Name(rawValue: "posts_removed"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("users.profile")
        NotificationCenter.default.removeObserver(self)
        interestLists.removeAllObjects()
    }
    @objc func getAllInterests(){
        let cell = profileTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MZProfileInterestsTableViewCell
        self.interestLists = Meteor.meteorClient?.collections["interests"] as! M13MutableOrderedDictionary
        cell.profileInterestCollectionView.reloadData()
    }
    
    @objc func getAllHangoutPosts ()
    {
        let cell = profileTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! ZGUserProfilePostsTableViewCell
        postsList = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        print(postsList)
        self.profileTableView.reloadSections(NSIndexSet(index: 2) as IndexSet, with: UITableView.RowAnimation.top)
    }
    @objc func updateAllHangoutPosts ()
    {
        let cell = profileTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! ZGUserProfilePostsTableViewCell
        postsList = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        print(postsList)
        self.profileTableView.reloadSections(NSIndexSet(index: 2) as IndexSet, with: UITableView.RowAnimation.top)
    }
    @objc func removeAllHangoutPosts ()
    {
        let cell = profileTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! ZGUserProfilePostsTableViewCell
        postsList = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        print(postsList)
        self.profileTableView.reloadSections(NSIndexSet(index: 2) as IndexSet, with: UITableView.RowAnimation.top)
    }
    
    

    
    func fadeAnimationForNavigationTitle (){
        let fadeTextAnimation : CATransition = CATransition()
        fadeTextAnimation.duration = 5
        fadeTextAnimation.type = .fade
        self.navigationItem.titleView?.layer.add(fadeTextAnimation, forKey: "fadeTitle")
    }
}
extension ZGUserProfileViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(interestLists.count)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interest", for: indexPath) as! ZGUserProfileCollectionViewCell
        let currentIndex = interestLists.object(at: UInt(indexPath.row))
        cell.interestLabel.text = currentIndex["title"] as! String
        cell.interestImageView.kf.indicatorType = .activity
        cell.interestImageView.kf.setImage(with: URL(string: currentIndex["image"] as! String))
        return cell
    }
}
extension ZGUserProfileViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? Int(postsList.count) : 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            //let cell = tableView.dequeueReusableCell(withIdentifier: "Mybrief") as! MyBriefTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "brief") as! ZGUserProfileBreifTableViewCell
            
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MZProfileInterestsTableViewCell") as! MZProfileInterestsTableViewCell
            return cell
        }
        else{
            unowned let  currentIndex = postsList.object(at: UInt(indexPath.row))
            let cell = tableView.dequeueReusableCell(withIdentifier: "news") as! ZGUserProfilePostsTableViewCell
            let userProfile = currentIndex["profile"] as! [String:Any]
            cell.hangImageView.kf.setImage(with: URL(string: userProfile["image"] as! String))
            cell.likeCountLabel.text = "\((currentIndex["lovesCount"] as? Int)!)"
            cell.commentCountLabel.text = "\((currentIndex["commentsCount"] as? Int)!)"
            cell.hangDescriptionLabel.text = currentIndex["description"] as? String
            
            return cell
        }
    }
}
extension ZGUserProfileViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0{

            self.title = "  "
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            
            self.title = "zyad galal"
        }
    }
}
