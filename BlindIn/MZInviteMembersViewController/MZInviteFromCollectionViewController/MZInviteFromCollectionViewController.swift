//
//  MZInviteFromCollectionViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/2/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP

class MZInviteFromCollectionViewController: UIViewController {

    @IBOutlet weak var nearbyMemberCollectionView: UICollectionView!
    @IBOutlet weak var bestiesCollectionView: UICollectionView!
    
    let hangoutCreationInfo = HangoutCreation()
    var invitedIDsArray : [String] = []
    
    var nearbyLists = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var bestieLists = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        nearbyMemberCollectionView.allowsMultipleSelection = true
        bestiesCollectionView.allowsMultipleSelection = true
        
        let name = UIBarButtonItem(title: "Create", style: .plain, target: self, action:#selector(tapButton) )
        self.navigationItem.setRightBarButton(name, animated: false)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Meteor.meteorClient?.addSubscription("users.nearby")
        NotificationCenter.default.addObserver(self, selector: #selector(MZInviteFromCollectionViewController.getAllNearby), name: NSNotification.Name(rawValue: "nearby_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZInviteFromCollectionViewController.getAllNearby), name: NSNotification.Name(rawValue: "nearby_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZInviteFromCollectionViewController.getAllNearby), name: NSNotification.Name(rawValue: "nearby_removed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZInviteFromCollectionViewController.getAllBesties), name: NSNotification.Name(rawValue: "besties_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZInviteFromCollectionViewController.getAllBesties), name: NSNotification.Name(rawValue: "besties_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZInviteFromCollectionViewController.getAllBesties), name: NSNotification.Name(rawValue: "besties_removed"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("users.nearby")
        NotificationCenter.default.removeObserver(self)
        nearbyLists.removeAllObjects()
        bestieLists.removeAllObjects()
    }
    @objc func getAllNearby(){
        self.nearbyLists = Meteor.meteorClient?.collections["nearby"] as! M13MutableOrderedDictionary
        print(nearbyLists)
        nearbyMemberCollectionView.reloadData()
    }
    @objc func getAllBesties(){
        self.bestieLists = Meteor.meteorClient?.collections["besties"] as! M13MutableOrderedDictionary
        print(bestieLists)
        bestiesCollectionView.reloadData()
    }
    @objc func tapButton(){
        hangoutCreationInfo.invites = invitedIDsArray
        print("***************************")
        print(hangoutCreationInfo.title)
        print(hangoutCreationInfo.locationID)
        print(hangoutCreationInfo.startDate)
        print(hangoutCreationInfo.endDate)
        print(hangoutCreationInfo.isPublic)
        print(hangoutCreationInfo.requireRequest)
        print(hangoutCreationInfo.description)
        print(hangoutCreationInfo.interests)
        print(hangoutCreationInfo.max)
        print(hangoutCreationInfo.gender)
        print(hangoutCreationInfo.invites)
        print("******************************")
        var params : [String : String] = [:]
        params = ["title" : hangoutCreationInfo.title
            ,"location" : hangoutCreationInfo.locationID
            , "startDate" : hangoutCreationInfo.startDate
            , "endDate" : hangoutCreationInfo.endDate
            , "isPublic" : hangoutCreationInfo.isPublic
            , "requiresRequests" : hangoutCreationInfo.requireRequest
            , "description" : hangoutCreationInfo.description
            , "interests" : hangoutCreationInfo.interests
            , "max" : hangoutCreationInfo.max
            , "gender" : hangoutCreationInfo.gender
            , "invites" : hangoutCreationInfo.invites ] as! [String : String]
        if Meteor.meteorClient?.connected == true{
            Meteor.meteorClient?.callMethodName("hangouts.methods.create", parameters: [params], responseCallback: { (response, error) in
                if error != nil{
                    print(error)
                }
                else{
                    print(response)
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }
        else{
            print("not connected")
        }



        
    }
}

extension MZInviteFromCollectionViewController : UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var return_Value = 0
        if collectionView == nearbyMemberCollectionView{
            return_Value = Int(nearbyLists.count)
        }
        else if collectionView == bestiesCollectionView{
            return_Value = Int(bestieLists.count)
        }
        return return_Value
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == nearbyMemberCollectionView {
            // Place content into hashtag cells
            let nearbyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MZNearbyMemberCollectionViewCell", for: indexPath) as! MZNearbyMemberCollectionViewCell
            let currentIndex = nearbyLists.object(at: UInt(indexPath.row))
            let nearbyProfile = currentIndex["profile"]! as! [String : Any]
            nearbyCell.nearbyMemberNameLabel.text = nearbyProfile["firstName"] as! String
            
            return nearbyCell
        } else if collectionView == bestiesCollectionView {
            // Place content in creators cell
            let bestieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MZBestiesCollectionViewCell", for: indexPath) as! MZBestiesCollectionViewCell
            let currentIndex = bestieLists.object(at: UInt(indexPath.row))
            let bestieProfile = currentIndex["profile"]! as! [String : Any]
            bestieCell.bestieNameLabel.text = bestieProfile["firstName"] as! String
            
            return bestieCell
        } else {
            preconditionFailure("Unknown collection view!")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/4)  , height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == nearbyMemberCollectionView{
            let currentNearby = nearbyLists.object(at: UInt(indexPath.row))
            invitedIDsArray.append((currentNearby["_id"] as? String)!)
            print(invitedIDsArray)
        }
        else if collectionView == bestiesCollectionView{
            let currentBestie = bestieLists.object(at: UInt(indexPath.row))
            invitedIDsArray.append((currentBestie["_id"] as? String)!)
            print(invitedIDsArray)
        }
    
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if collectionView == nearbyMemberCollectionView{
            let currentNearby = nearbyLists.object(at: UInt(indexPath.row))
            invitedIDsArray.removeAll {$0 == currentNearby["_id"] as! String}
        }
        else if collectionView == bestiesCollectionView{
            let currentBestie = bestieLists.object(at: UInt(indexPath.row))
            invitedIDsArray.removeAll {$0 == currentBestie["_id"] as! String}
        
        }
    
    }
    
}
