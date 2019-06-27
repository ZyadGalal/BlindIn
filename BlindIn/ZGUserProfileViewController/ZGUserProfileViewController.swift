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
    var profileList = M13MutableOrderedDictionary<NSCopying, AnyObject>()


    @IBOutlet weak var profileTableView: UITableView!
    //----------NEED TO TEST--------
    var id : String = ""
    var cellChecker : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fadeAnimationForNavigationTitle()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (id == Meteor.meteorClient!.userId){
            cellChecker = 0
        }
        else{
            cellChecker = 1
        }
        //var id : String = Meteor.meteorClient!.userId
        print(id)
        Meteor.meteorClient?.addSubscription("users.profile", withParameters: [["userId":id]] )
        //---------------------------------------------------------
        NotificationCenter.default.addObserver(self, selector: #selector(ZGUserProfileViewController.getAllInterests), name: NSNotification.Name(rawValue: "interests_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ZGUserProfileViewController.getAllInterests), name: NSNotification.Name(rawValue: "interests_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ZGUserProfileViewController.getAllInterests), name: NSNotification.Name(rawValue: "interests_removed"), object: nil)
        //---------------------------------------------------------
        NotificationCenter.default.addObserver(self, selector: #selector(ZGUserProfileViewController.getAllHangoutPosts), name: NSNotification.Name(rawValue: "posts_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ZGUserProfileViewController.updateAllHangoutPosts), name: NSNotification.Name(rawValue: "posts_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ZGUserProfileViewController.removeAllHangoutPosts), name: NSNotification.Name(rawValue: "posts_removed"), object: nil)
        //-----------------------------------------------------------
        NotificationCenter.default.addObserver(self, selector: #selector(ZGUserProfileViewController.getProfile), name: NSNotification.Name(rawValue: "profile_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ZGUserProfileViewController.updateProfile), name: NSNotification.Name(rawValue: "profile_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ZGUserProfileViewController.removeProfile), name: NSNotification.Name(rawValue: "profile_removed"), object: nil)
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
        postsList = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        print(postsList)
        self.profileTableView.reloadSections(NSIndexSet(index: 2) as IndexSet, with: UITableView.RowAnimation.top)
    }
    @objc func updateAllHangoutPosts ()
    {
        postsList = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        print(postsList)
        self.profileTableView.reloadSections(NSIndexSet(index: 2) as IndexSet, with: UITableView.RowAnimation.top)
    }
    @objc func removeAllHangoutPosts ()
    {
        postsList = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        print(postsList)
        self.profileTableView.reloadSections(NSIndexSet(index: 2) as IndexSet, with: UITableView.RowAnimation.top)
    }
    
    @objc func getProfile ()
    {
        profileList = Meteor.meteorClient?.collections["profile"] as! M13MutableOrderedDictionary
        print(profileList)
        self.profileTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableView.RowAnimation.top)
    }
    @objc func updateProfile ()
    {
        profileList = Meteor.meteorClient?.collections["profile"] as! M13MutableOrderedDictionary
        print(profileList)
        profileTableView.reloadData()
        //self.profileTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableView.RowAnimation.top)
    }
    @objc func removeProfile ()
    {
        profileList = Meteor.meteorClient?.collections["profile"] as! M13MutableOrderedDictionary
        print(profileList)
        profileTableView.reloadData()
    }
    @objc func followButtonClicked (sender : UIButton)
    {
        if (sender.titleLabel?.text == "Following"){
        if (Meteor.meteorClient?.collections["profile"]) != nil {
            let current = profileList.object(at: UInt(0))
            var id = current["_id"] as! String
            print(id)
            
            if Meteor.meteorClient?.connected == true{
                Meteor.meteorClient?.callMethodName("users.methods.follow", parameters: [["userId" : id]], responseCallback: { (response, error) in
                    if error != nil{
                        print(error)
                    }
                    else{
                        sender.titleLabel?.text = "Follow"
                        print(response)
                        
                    }
                })
            }
            else{
                print("not connected")
            }
        }
        }else if(sender.titleLabel?.text == "Follow"){
            if (Meteor.meteorClient?.collections["profile"]) != nil {
                let current = profileList.object(at: UInt(0))
                var id = current["_id"] as! String
                print(id)
                
                if Meteor.meteorClient?.connected == true{
                    Meteor.meteorClient?.callMethodName("users.methods.follow", parameters: [["userId" : id]], responseCallback: { (response, error) in
                        if error != nil{
                            print(error)
                        }
                        else{
                            sender.titleLabel?.text = "Following"
                            print(response)
                            
                        }
                    })
                }
                else{
                    print("not connected")
                }
            }
        }
        
    }
    
    @objc func addBestieButtonClicked (sender : UIButton)
    {
            if (sender.currentImage == UIImage(named: "like")){
            if (Meteor.meteorClient?.collections["profile"]) != nil {
                let current = profileList.object(at: UInt(0))
                var id = current["_id"] as! String
                print(id)
                
                if Meteor.meteorClient?.connected == true{
                    Meteor.meteorClient?.callMethodName("users.methods.invite-bestie", parameters: [["userId" : id]], responseCallback: { (response, error) in
                        if error != nil{
                            print(error)
                        }
                        else{
                            sender.setImage(UIImage(named: "1"), for: .normal)
                            print(response)
                            
                        }
                    })
                }
                else{
                    print("not connected")
                }
            }
        }else {
            if (Meteor.meteorClient?.collections["profile"]) != nil {
                let current = profileList.object(at: UInt(0))
                var id = current["_id"] as! String
                print(id)
                
                if Meteor.meteorClient?.connected == true{
                    Meteor.meteorClient?.callMethodName("users.methods.invite-bestie", parameters: [["userId" : id]], responseCallback: { (response, error) in
                        if error != nil{
                            print(error)
                        }
                        else{
                            sender.setImage(UIImage(named: "like"), for: .normal)
                            print(response)
                            
                        }
                    })
                }
                else{
                    print("not connected")
                }
            }
        }

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
        var check = 0
        if(Meteor.meteorClient?.collections["interests"] != nil){
            check = Int(interestLists.count)
        }
        return check
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interest", for: indexPath) as! ZGUserProfileCollectionViewCell
        let currentIndex = interestLists.object(at: UInt(indexPath.row))
        cell.interestLabel.text = (currentIndex["title"] as! String)
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
        var check = 0
        if (Meteor.meteorClient?.collections["posts"]) != nil{
            check = Int(postsList.count)
        }
        return section == 2 ? check : 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            
            if cellChecker == 0 {
                let myBriefcell = tableView.dequeueReusableCell(withIdentifier: "Mybrief") as! MyBriefTableViewCell
                if (Meteor.meteorClient?.collections["profile"]) != nil {
                let current = profileList.object(at: UInt(0))
                let profile = current["profile"] as! [String : Any]
                    myBriefcell.username.text = "\(profile["firstName"] as! String) \(profile["lastName"] as! String)"
                    myBriefcell.userDescription.text = (profile["bio"] as! String)
                    myBriefcell.userImg.kf.indicatorType = .activity
                    myBriefcell.userImg.kf.setImage(with: URL(string: profile["image"] as! String))
                    myBriefcell.followingLabel.text = (profile["profile.followingCount"] as! String)
                    myBriefcell.followersLbl.text = (profile["profile.followersCount"] as! String)
                    myBriefcell.hangoutsLabel.text = (profile["profile.joinedHangoutsCount"] as! String)

                }

                return myBriefcell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "brief") as! ZGUserProfileBreifTableViewCell

                if (Meteor.meteorClient?.collections["profile"]) != nil {
                    let current = profileList.object(at: UInt(0))
                    let profile = current["profile"] as! [String : Any]
                    let followers = profile["followers"] as! [String]
                    let following = profile["following"] as! [String]
                    let joinedHangout = profile["joinedHangouts"] as! [String]
                    let besties = profile["besties"] as! [String]
                    cell.username.text = "\(profile["firstName"] as! String) \(profile["lastName"] as! String)"
                    cell.userDescription.text = (profile["bio"] as! String)
                    cell.userImg.kf.indicatorType = .activity
                    cell.userImg.kf.setImage(with: URL(string: profile["image"] as! String))
                    cell.followingLabel.text = String(following.count)
                    cell.followersLbl.text = String(followers.count)
                    cell.hangoutsLabel.text = String(joinedHangout.count)
                    cell.followButton.addTarget(self, action: #selector(ZGUserProfileViewController.followButtonClicked), for: .touchUpInside)
                    cell.addBestieButton.addTarget(self, action: #selector(ZGUserProfileViewController.addBestieButtonClicked), for: .touchUpInside)
                    if followers.contains(current["_id"] as! String){
                        print("sa7 ya amer")
                        cell.followButton.setTitle("Following", for: .normal)
                    }
                    if besties.contains(current["_id"] as! String){
                        cell.addBestieButton.setImage(UIImage(named: "1"), for: .selected)
                    }
   
                }
                return cell
            }
            
            
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MZProfileInterestsTableViewCell") as! MZProfileInterestsTableViewCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "news") as! ZGUserProfilePostsTableViewCell
            if (Meteor.meteorClient?.collections["posts"]) != nil {
            unowned let  currentIndex = postsList.object(at: UInt(indexPath.row))
            cell.hangImageView.kf.setImage(with: URL(string: currentIndex["image"] as! String))
            cell.likeCountLabel.text = "\((currentIndex["lovesCount"] as? Int)!)"
            cell.commentCountLabel.text = "\((currentIndex["commentsCount"] as? Int)!)"
            cell.hangDescriptionLabel.text = currentIndex["description"] as? String
        
            }
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
