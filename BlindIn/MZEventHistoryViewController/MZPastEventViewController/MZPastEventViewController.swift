//
//  MZPastEventViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZPastEventViewController: UIViewController {

    
    var pastEvents = ["Momen","Momen Adel","Momen Adel Mohamed","Mo2a","El Mo2"]
    var locations = ["Mansoura" , "Cairo" , "Alexandria","Giza","Sharm"]
    var date = ["1/10/2019","12/9/2019","29/5/2019","7/7/2019","1/1/2019"]
    
    
    @IBOutlet weak var pastEventsTabelView: UITableView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
         pastEventsTabelView.register(UINib(nibName: "MZBothEventTableViewCell", bundle: nil), forCellReuseIdentifier: "MZPastEventTableViewCell")

        // Do any additional setup after loading the view.
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
