//
//  ZGUserProfileViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/5/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class ZGUserProfileViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        fadeAnimationForNavigationTitle()
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
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interest", for: indexPath) as! ZGUserProfileCollectionViewCell
        cell.interestLabel.text = "fortnite"
        cell.interestImageView.image = UIImage(named: "1")
        return cell
    }
}
extension ZGUserProfileViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? 10 : 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            //let cell = tableView.dequeueReusableCell(withIdentifier: "Mybrief") as! MyBriefTableViewCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "brief") as! ZGUserProfileBreifTableViewCell
            
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "interestsCollectionView")
            return cell!
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "news") as! ZGUserProfilePostsTableViewCell
            cell.hangImageView.image = UIImage(named: "1")
            cell.likeCountLabel.text = "55555"
            cell.commentCountLabel.text = "10"
            cell.hangDescriptionLabel.text = "hi , i'm zyad mahmoud galal"
            
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
