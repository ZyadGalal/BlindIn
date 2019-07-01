//
//  MZUpcomingEventViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP

class MZUpcomingEventViewController: UIViewController {

    
    @IBOutlet weak var upcomingEventsTabelView: UITableView!
    
    var hangout = M13MutableOrderedDictionary<NSCopying, AnyObject>()

    override func viewDidLoad() {
        super.viewDidLoad()

        upcomingEventsTabelView.register(UINib(nibName: "MZBothEventTableViewCell", bundle: nil), forCellReuseIdentifier: "MZUpcomingEventTableViewCell")
        Meteor.meteorClient?.addSubscription("hangouts.mine")
        NotificationCenter.default.addObserver(self, selector: #selector(getPastHangouts), name: NSNotification.Name("upcoming_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getPastHangouts), name: NSNotification.Name("upcoming_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getPastHangouts), name: NSNotification.Name("upcoming_removed"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("hangout.mine")
        NotificationCenter.default.removeObserver(self)
        
    }

    @objc func getPastHangouts(){
        if Meteor.meteorClient?.collections["upcoming"] != nil{
            hangout = Meteor.meteorClient?.collections["upcoming"] as! M13MutableOrderedDictionary
            upcomingEventsTabelView.reloadData()
        }
    }
}

extension MZUpcomingEventViewController :  UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(hangout.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = upcomingEventsTabelView.dequeueReusableCell(withIdentifier: "MZUpcomingEventTableViewCell") as! MZBothEventTableViewCell
        let current = hangout.object(at: UInt(indexPath.row))
        cell.eventNameLabel.text = current["title"] as? String
        cell.eventDateLabel.text = current["endDate"] as? String
        cell.eventLocationLabel.text = current["locationTitle"] as? String
        cell.eventdescriptionLabel.text = current["description"] as? String
        cell.eventImageView.kf.setImage(with: URL(string: current["image"] as! String)!)
        cell.selectionStyle = .none
        
        return cell
    }
    
}
extension MZUpcomingEventViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let current = hangout.object(at: UInt(indexPath.row))
        let vc = UIStoryboard(name: "HangoutProfile", bundle: nil).instantiateViewController(withIdentifier: "ZGHangoutProfileViewController") as! ZGHangoutProfileViewController
        vc.hangoutId = current["_id"] as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
