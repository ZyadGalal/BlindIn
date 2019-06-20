//
//  MZInterestsViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP

class MZInterestsViewController: UIViewController {
    
    @IBOutlet weak var interestCollectionView: UICollectionView!
    
    var lists = M13MutableOrderedDictionary<NSCopying, AnyObject>()

    var idsArray : [String] = []
    override func viewDidLoad() {
        self.navigationItem.title = "Interests"
        super.viewDidLoad()
        interestCollectionView.allowsMultipleSelection = true
        Meteor.meteorClient?.addSubscription("interests.all")
        NotificationCenter.default.addObserver(self, selector: #selector(MZInterestsViewController.getAllInterests), name: NSNotification.Name(rawValue: "interests_added"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("interests.all")
        NotificationCenter.default.removeObserver(self)
        lists.removeAllObjects()
    }
    @objc func getAllInterests(){
        self.lists = Meteor.meteorClient?.collections["interests"] as! M13MutableOrderedDictionary
        interestCollectionView.reloadData()
    }
    @IBAction func nextButtonClicked(_ sender: Any) {
        print(idsArray)
        if Meteor.meteorClient?.connected == true{
            Meteor.meteorClient?.callMethodName("users.methods.update-interests", parameters: [["interests" : idsArray]], responseCallback: { (response, error) in
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

extension MZInterestsViewController : UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(lists.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  interestCollectionView.dequeueReusableCell(withReuseIdentifier: "interestsCell", for: indexPath) as! MZInterestsCollectionViewCell
        let currentIndex = lists.object(at: UInt(indexPath.row))
        cell.interestLabel.text = currentIndex["title"] as! String
        cell.interestImageView.image = UIImage(named: "1")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/3)  , height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let current = lists.object(at: UInt(indexPath.row))
        idsArray.append((current["_id"] as? String)!)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let current = lists.object(at: UInt(indexPath.row))

        idsArray.removeAll {$0 == current["_id"] as! String}
    }
}

