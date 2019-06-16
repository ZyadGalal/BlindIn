//
//  ExploreViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {

    let arr = ["1","1","1","1","1","1","1"]
    var flag = 1
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
extension ExploreViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows : Float = Float(arr.count)/3
        rows = rows.rounded(.up)
        let numOfRows : Int = Int(rows)
        print(numOfRows)
        return numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var multiplier = 3
        multiplier *= indexPath.row
        if flag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "right") as! ExploreTableViewCell
            if arr.indices.contains(multiplier)
            {
                cell.firstButton.setImage(UIImage(named: arr[multiplier]), for: .normal)
            }
            if arr.indices.contains(multiplier+1)
            {
                cell.secondButtom.setImage(UIImage(named: arr[multiplier+1]), for: .normal)
            }
            if arr.indices.contains(multiplier+2)
            {
                cell.thirdBtn.setImage(UIImage(named: arr[multiplier+2]), for: .normal)
            }
            flag = 2
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "left") as! ExploreTableViewCell
            if arr.indices.contains(multiplier)
            {
                cell.firstButton.setImage(UIImage(named: arr[multiplier]), for: .normal)
            }
            if arr.indices.contains(multiplier+1)
            {
                cell.secondButtom.setImage(UIImage(named: arr[multiplier+1]), for: .normal)
            }
            if arr.indices.contains(multiplier+2)
            {
                cell.thirdBtn.setImage(UIImage(named: arr[multiplier+2]), for: .normal)
            }
            flag = 1
            return cell
        }
    }
    
    
}
