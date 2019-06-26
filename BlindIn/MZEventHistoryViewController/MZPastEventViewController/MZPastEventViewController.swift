//
//  MZPastEventViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP

class MZPastEventViewController: UIViewController {

    var lists = M13MutableOrderedDictionary<NSCopying, AnyObject>()

    
    var pastEvents = ["Momen","Momen Adel","Momen Adel Mohamed","Mo2a","El Mo2"]
    var locations = ["Mansoura" , "Cairo" , "Alexandria","Giza","Sharm"]
    var date = ["1/10/2019","12/9/2019","29/5/2019","7/7/2019","1/1/2019"]
    
    
    @IBOutlet weak var pastEventsTabelView: UITableView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
         pastEventsTabelView.register(UINib(nibName: "MZBothEventTableViewCell", bundle: nil), forCellReuseIdentifier: "MZPastEventTableViewCell")

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        Meteor.meteorClient?.addSubscription("hangouts.mine")
        NotificationCenter.default.addObserver(self, selector: #selector(MZPastEventViewController.getAllHangout), name: NSNotification.Name(rawValue: "hangouts_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZPastEventViewController.getAllHangoutChanged), name: NSNotification.Name(rawValue: "hangouts_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZPastEventViewController.getAllHangoutRemoved), name: NSNotification.Name(rawValue: "hangouts_removed"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("hangouts.mine")
        NotificationCenter.default.removeObserver(self)
        lists.removeAllObjects()
    }
    
    @objc func getAllHangout(){
        
        self.lists = Meteor.meteorClient?.collections["hangouts"] as! M13MutableOrderedDictionary
        print(lists)
        
    }
    @objc func getAllHangoutChanged(){
        
    }
    @objc func getAllHangoutRemoved(){
        
    }

}

extension MZPastEventViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pastEventsTabelView.dequeueReusableCell(withIdentifier: "MZPastEventTableViewCell") as! MZBothEventTableViewCell
        cell.eventNameLabel.text = pastEvents[indexPath.row]
        cell.eventDateLabel.text = date[indexPath.row]
        cell.eventLocationLabel.text = locations[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
  
}
