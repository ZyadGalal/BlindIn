//
//  MZPastEventViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP
import Kingfisher

class MZPastEventViewController: UIViewController {

    
    var pastEvents = ["Momen","Momen Adel","Momen Adel Mohamed","Mo2a","El Mo2"]
    var locations = ["Mansoura" , "Cairo" , "Alexandria","Giza","Sharm"]
    var date = ["1/10/2019","12/9/2019","29/5/2019","7/7/2019","1/1/2019"]
    
    
    @IBOutlet weak var pastEventsTabelView: UITableView!
    
    var hangout = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         pastEventsTabelView.register(UINib(nibName: "MZBothEventTableViewCell", bundle: nil), forCellReuseIdentifier: "MZPastEventTableViewCell")

        Meteor.meteorClient?.addSubscription("hangouts.mine")
        NotificationCenter.default.addObserver(self, selector: #selector(getPastHangouts), name: NSNotification.Name("history_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getPastHangouts), name: NSNotification.Name("history_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getPastHangouts), name: NSNotification.Name("history_removed"), object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("hangout.mine")
        NotificationCenter.default.removeObserver(self)
    }
    @objc func getPastHangouts(){
        if Meteor.meteorClient?.collections["history"] != nil{
            hangout = Meteor.meteorClient?.collections["history"] as! M13MutableOrderedDictionary
            pastEventsTabelView.reloadData()
        }
    }
}

extension MZPastEventViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(hangout.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pastEventsTabelView.dequeueReusableCell(withIdentifier: "MZPastEventTableViewCell") as! MZBothEventTableViewCell
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
