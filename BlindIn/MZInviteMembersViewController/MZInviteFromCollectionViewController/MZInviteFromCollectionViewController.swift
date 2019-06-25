//
//  MZInviteFromCollectionViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/2/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP
import Kingfisher

class MZInviteFromCollectionViewController: UIViewController {

    @IBOutlet weak var nearbyMemberCollectionView: UICollectionView!
    @IBOutlet weak var bestiesCollectionView: UICollectionView!

    
    var invitedIDsArray : [String] = []
    
    
    var nearbyLists = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var bestieLists = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        nearbyMemberCollectionView.allowsMultipleSelection = true
        bestiesCollectionView.allowsMultipleSelection = true
        
        
        
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
            nearbyCell.nearbyMemberImageView.kf.indicatorType = .activity
            nearbyCell.nearbyMemberImageView.kf.setImage(with: URL(string: nearbyProfile["image"] as! String))
            return nearbyCell
        } else if collectionView == bestiesCollectionView {
            // Place content in creators cell
            let bestieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MZBestiesCollectionViewCell", for: indexPath) as! MZBestiesCollectionViewCell
            let currentIndex = bestieLists.object(at: UInt(indexPath.row))
            let bestieProfile = currentIndex["profile"]! as! [String : Any]
            bestieCell.bestieNameLabel.text = bestieProfile["firstName"] as! String
            bestieCell.bestieImageView.kf.indicatorType = .activity
            bestieCell.bestieImageView.kf.setImage(with: URL(string: bestieProfile["image"] as! String))
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
