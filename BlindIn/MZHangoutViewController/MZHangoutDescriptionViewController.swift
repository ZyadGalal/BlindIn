//
//  MZHangoutDescriptionViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP
import TextFieldEffects

class MZHangoutDescriptionViewController: UIViewController {

    var lists = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var idsArray : [String] = []
    
    var interest : [String] = []
    var hangTitle : String = ""
    var hangStartDate : String = ""
    var hangEndDate : String = ""
    var hangPublic : String = ""
    var hangWithRequest : String = ""
    var hangLocationID : String = ""
    var locationName : String = ""
    var locationType : String = ""
    var locationAdress : String = ""
    var lat : String = ""
    var long : String = ""
    var city : String = ""
    var country : String = ""
    
    
    @IBOutlet weak var hangoutDescreptionTextField: HoshiTextField!
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var popUpUIView: UIView!
    @IBOutlet weak var interestsTableView: UITableView!
    @IBOutlet weak var centerPopUpConstrain: NSLayoutConstraint!
    @IBOutlet weak var interestLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpUIView.layer.cornerRadius = 10
        popUpUIView.layer.masksToBounds = true
        
        let name = UIBarButtonItem(title: "Next", style: .plain, target: self, action:#selector(tapButton) )
        self.navigationItem.setRightBarButton(name, animated: false)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Meteor.meteorClient?.addSubscription("interests.all")
        NotificationCenter.default.addObserver(self, selector: #selector(MZHangoutDescriptionViewController.getAllInterests), name: NSNotification.Name(rawValue: "interests_added"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZHangoutDescriptionViewController.getAllInterests), name: NSNotification.Name(rawValue: "interests_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MZHangoutDescriptionViewController.getAllInterests), name: NSNotification.Name(rawValue: "interests_removed"), object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("interests.all")
        NotificationCenter.default.removeObserver(self)
        lists.removeAllObjects()
    }
    
    @IBAction func popUpButtonPressed(_ sender: Any) {
        centerPopUpConstrain.constant = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0.5
            
        })
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        centerPopUpConstrain.constant = -350
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0
        })
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        var interests :String = ""
        for inter in interest{
            interests.append("\(inter) ,")
        }
        interestLabel.text = "\(interests)"
        interestLabel.textColor = UIColor.black
        centerPopUpConstrain.constant = -350
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0
        })
        
        print(idsArray)
        if Meteor.meteorClient?.connected == true{
            Meteor.meteorClient?.callMethodName("users.methods.update-interests", parameters: [["interests" : idsArray]], responseCallback: { (response, error) in
                if error != nil{
                    print(error)
                }
                else{
                    print(response)
                }
            })
        }
        else{
            print("not connected")
            let alert = UIAlertController(title: "Alert", message: "Check Your Connection", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @objc func tapButton(){

        let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZHangoutMembersLimitViewController") as! MZHangoutMembersLimitViewController
        
        vc.hangTitle = hangTitle
        vc.hangStartDate = hangStartDate
        vc.hangEndDate = hangEndDate
        vc.hangPublic = hangPublic
        vc.hangWithRequest = hangWithRequest
        if hangLocationID != "" {
            vc.hangLocationID = hangLocationID
        }
        else{
            vc.locationName = locationName
            vc.locationAdress = locationAdress
            vc.locationType = locationType
            vc.lat = lat
            vc.long = long
            vc.city = city
            vc.country = country
        }
        vc.hangDesc = hangoutDescreptionTextField.text!
        vc.hangInterests = idsArray
   
        print(vc.hangTitle)
        print(vc.hangStartDate)
        print(vc.hangEndDate)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func getAllInterests(){
        self.lists = Meteor.meteorClient?.collections["interests"] as! M13MutableOrderedDictionary
        interestsTableView.reloadData()
    }
    
}

extension MZHangoutDescriptionViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(lists.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = interestsTableView.dequeueReusableCell(withIdentifier: "interestCell") as! MZInterestTableViewCell
        cell.selectionStyle = .none
        let currentIndex = lists.object(at: UInt(indexPath.row))
        cell.interestNameLabel.text = currentIndex["title"] as! String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = interestsTableView.dequeueReusableCell(withIdentifier: "interestCell") as! MZInterestTableViewCell
        let current = lists.object(at: UInt(indexPath.row))
        if interestsTableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none {
            interestsTableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            interest.append(current["title"] as! String)
            idsArray.append((current["_id"] as? String)!)
        }
        else{
            interestsTableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            interest.remove(at: indexPath.row)
            idsArray.removeAll {$0 == current["_id"] as! String}
        }
        print(idsArray)
    }
    
    
    
}
