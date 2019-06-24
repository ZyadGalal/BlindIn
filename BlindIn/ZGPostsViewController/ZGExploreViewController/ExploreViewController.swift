//
//  ExploreViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP

class ExploreViewController: UIViewController {

    @IBOutlet weak var exploreTableView: UITableView!
    var explorePosts = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var flag = 1
    var arr : [AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    @IBAction func ExplorePostButtonClicked(_ sender: UIButton) {
        if let postId = sender.accessibilityIdentifier {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZGPostsDetailsViewController") as! ZGPostsDetailsViewController
            vc.postId = postId
            //vc.indexClicked = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        Meteor.meteorClient?.addSubscription("posts.explore")
        NotificationCenter.default.addObserver(self, selector: #selector(getExplores), name: NSNotification.Name("posts_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateExplore), name: NSNotification.Name("posts_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeExplore), name: NSNotification.Name("posts_removed"), object: nil)
    }
    @objc func getExplores (){
        flag = 1
        explorePosts = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        arr = explorePosts.allObjects

        exploreTableView.reloadData()
    }
    @objc func updateExplore(){
        flag = 1

        explorePosts = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        arr = explorePosts.allObjects
        exploreTableView.reloadData()
    }
    @objc func removeExplore(){
        flag = 1

        explorePosts = Meteor.meteorClient?.collections["posts"] as! M13MutableOrderedDictionary
        arr = explorePosts.allObjects
        exploreTableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("posts.explore")
        NotificationCenter.default.removeObserver(self)
        arr.removeAll()
        exploreTableView.reloadData()
    }
}
extension ExploreViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows : Float = Float(explorePosts.count)/3
        rows = rows.rounded(.up)
        let numOfRows : Int = Int(rows)
        return numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var multiplier = 3
        multiplier *= indexPath.row
        if flag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "right") as! ExploreTableViewCell
            cell.selectionStyle = .none
            
            if arr.indices.contains(multiplier)
            {
                let object = arr[multiplier] as! [String:Any]
                cell.firstButton.kf.setImage(with: URL(string: object["image"] as! String), for: .normal)
                cell.firstButton.accessibilityIdentifier = object["_id"] as? String
            }
            if arr.indices.contains(multiplier+1)
            {
                let object = arr[multiplier+1] as! [String:Any]
                cell.secondButtom.kf.setImage(with: URL(string: object["image"] as! String), for: .normal)
                cell.secondButtom.accessibilityIdentifier = object["_id"] as? String
            }
            if arr.indices.contains(multiplier+2)
            {
                let object = arr[multiplier+2] as! [String:Any]
                cell.thirdBtn.kf.setImage(with: URL(string: object["image"] as! String), for: .normal)
                cell.thirdBtn.accessibilityIdentifier = object["_id"] as? String
            }
            flag = 2
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "left") as! ExploreTableViewCell
            cell.selectionStyle = .none
            let arr = explorePosts.allObjects
            if arr.indices.contains(multiplier)
            {
                let object = arr[multiplier] as! [String:Any]
                cell.firstButton.kf.setImage(with: URL(string: object["image"] as! String), for: .normal)
                cell.firstButton.accessibilityIdentifier = object["_id"] as? String
            }
            if arr.indices.contains(multiplier+1)
            {
                let object = arr[multiplier+1] as! [String:Any]
                cell.secondButtom.kf.setImage(with: URL(string: object["image"] as! String), for: .normal)
                cell.secondButtom.accessibilityIdentifier = object["_id"] as? String
            }
            if arr.indices.contains(multiplier+2)
            {
                let object = arr[multiplier+2] as! [String:Any]
                cell.thirdBtn.kf.setImage(with: URL(string: object["image"] as! String), for: .normal)
                cell.thirdBtn.accessibilityIdentifier = object["_id"] as? String
                print(multiplier+2)
            }
            flag = 1
            return cell
        }
    }
}

