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
    var username : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        fadeAnimationForNavigationTitle()
        self.navigationController?.setNavigationBarHidden(false, animated: false)

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
        Meteor.meteorClient?.collections["interests"] = nil
        Meteor.meteorClient?.collections["posts"] = nil
        Meteor.meteorClient?.collections["profile"] = nil

    
    }
    @objc func getAllInterests(){
        if profileTableView.cellForRow(at: IndexPath(row: 0, section: 1)) != nil{
        let cell = profileTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MZProfileInterestsTableViewCell
        self.interestLists = Meteor.meteorClient?.collections["interests"] as! M13MutableOrderedDictionary
        cell.profileInterestCollectionView.reloadData()
        }
    }
    
    @objc func getAllHangoutPosts ()
    {
        postsList = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        print(postsList)
        self.profileTableView.reloadData()
    }
    @objc func updateAllHangoutPosts ()
    {
        postsList = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        print(postsList)
        self.profileTableView.reloadData()
    }
    @objc func removeAllHangoutPosts ()
    {
        postsList = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        print(postsList)
        self.profileTableView.reloadData()
    }
    
    @objc func getProfile ()
    {
        profileList = Meteor.meteorClient?.collections["profile"] as! M13MutableOrderedDictionary
        print(profileList)
        self.profileTableView.reloadData()
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
            if (sender.currentImage == UIImage(named: "gold-star")){
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
                            sender.setImage(UIImage(named: "star"), for: .normal)
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
                            sender.setImage(UIImage(named: "gold-star"), for: .normal)
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
        if Meteor.meteorClient?.collections["interests"] != nil{
            let currentIndex = interestLists.object(at: UInt(indexPath.row))
            cell.interestLabel.text = (currentIndex["title"] as! String)
            cell.interestImageView.kf.indicatorType = .activity
            cell.interestImageView.kf.setImage(with: URL(string: currentIndex["image"] as! String))
        }
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
                    username = "\(profile["firstName"] as! String) \(profile["lastName"] as! String)"
                    myBriefcell.username.text = "\(profile["firstName"] as! String) \(profile["lastName"] as! String)"
                    myBriefcell.userDescription.text = (profile["bio"] as! String)
                    myBriefcell.userImg.kf.indicatorType = .activity
                    myBriefcell.userImg.kf.setImage(with: URL(string: profile["image"] as! String))
                    myBriefcell.followingLabel.text = "\((profile["followingCount"] as! Int))"
                    myBriefcell.followersLbl.text = "\((profile["followersCount"] as! Int))"
                    myBriefcell.hangoutsLabel.text = "\((current["profile.joinedHangoutsCount"] as! Int))"

                }
                myBriefcell.selectionStyle = .none
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
                    username = "\(profile["firstName"] as! String) \(profile["lastName"] as! String)"
                    cell.username.text = "\(profile["firstName"] as! String) \(profile["lastName"] as! String)"
                    cell.userDescription.text = (profile["bio"] as! String)
                    cell.userImg.kf.indicatorType = .activity
                    cell.userImg.kf.setImage(with: URL(string: profile["image"] as! String))
                    cell.followingLabel.text = String(following.count)
                    cell.followersLbl.text = String(followers.count)
                    cell.hangoutsLabel.text = String(joinedHangout.count)
                    cell.followButton.addTarget(self, action: #selector(ZGUserProfileViewController.followButtonClicked), for: .touchUpInside)
                    cell.addBestieButton.addTarget(self, action: #selector(ZGUserProfileViewController.addBestieButtonClicked), for: .touchUpInside)
                    if followers.contains((Meteor.meteorClient?.userId)!){
                        cell.followButton.setTitle("Following", for: .normal)
                    }
                    if besties.contains(current["_id"] as! String){
                        cell.addBestieButton.setImage(UIImage(named: "golde-star"), for: .normal)
                    }
   
                }
                cell.selectionStyle = .none

                return cell
            }
            
            
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MZProfileInterestsTableViewCell") as! MZProfileInterestsTableViewCell
            cell.selectionStyle = .none

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
            cell.likeButton.tag = indexPath.row
            let loveArray = currentIndex["loves"] as? [String]
            if (loveArray?.contains((Meteor.meteorClient?.userId)!)) == true{
                cell.likeButton.setImage(UIImage(named:"like"), for: .normal)
            }
            else{
                cell.likeButton.setImage(UIImage(named:"unlike"), for: .normal)
            }
            }
            cell.selectionStyle = .none	

            return cell
        }
        
    }
    
}
extension ZGUserProfileViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            let currentIndex = postsList.object(at: UInt(indexPath.row))
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZGPostsDetailsViewController") as! ZGPostsDetailsViewController
            vc.postId = currentIndex["_id"] as? String
            //vc.indexClicked = indexPath.row
            
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0{

            self.title = "  "
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if username != nil{
                self.title = username!
            }
        }
    }
}
