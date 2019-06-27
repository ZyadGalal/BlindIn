
//
//  ZGMoreViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/17/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class ZGMoreViewController: UIViewController {

    let tabsImages = ["profile","offers","key","group","glasses","info","logout"]
    let tabsTitle = ["profile","offers","account pref","bestie","hangout history","about","logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
extension ZGMoreViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabsImages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "more") as! ZGMoreTableViewCell
        cell.moreImageView.image = UIImage(named: tabsImages[indexPath.row])
        cell.moreLabel.text = tabsTitle[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
extension ZGMoreViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZGEditProfileViewController") as! ZGEditProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 4{
            let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZEventHistoryViewController") as! MZEventHistoryViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
