//
//  MZInviteMembersViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/3/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP

class MZInviteMembersViewController: UIViewController {
    
    let segment: UISegmentedControl = UISegmentedControl(items: ["First", "Second"])
    let invFromCollection = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZInviteFromCollectionViewController") as! MZInviteFromCollectionViewController
    let invFromMap = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZInviteFromMapViewController") as! MZInviteFromMapViewController

    var invitedIDsArray : [String] = []
    var hangTitle : String = ""
    var hangStartDate : String = ""
    var hangEndDate : String = ""
    var hangPublic : String = ""
    var hangWithRequest : String = ""
    var hangLocationID : String = ""
    var hangMax : String = ""
    var hangGender : String = ""
    var hangDesc : String = ""
    var hangInterests : [String] = []
    //-----------Custom Location
    var locationName : String = ""
    var locationType : String = ""
    var locationAdress : String = ""
    var lat : String = ""
    var long : String = ""
    var city : String = ""
    var country : String = ""
    
    var nearbyLists = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var bestieLists = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let name = UIBarButtonItem(title: "Create", style: .plain, target: self, action:#selector(tapButton) )
        self.navigationItem.setRightBarButton(name, animated: false)
        
        //Segment Creation
        segment.sizeToFit()
        segment.tintColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
        segment.selectedSegmentIndex = 0
        //-------------
        self.addChild(invFromMap)
        self.containerView.addSubview(invFromMap.view)
        invFromMap.didMove(toParent: self)
        self.addChild(invFromMap)
        self.invFromMap.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
        //-------------
        self.navigationItem.titleView = segment
        segment.addTarget(self, action: #selector(indexChanged(sender:)), for: .valueChanged)
    }
    
    @objc func indexChanged( sender: UISegmentedControl) {
        childRemove()
        if segment.selectedSegmentIndex == 0 {
            self.addChild(invFromMap)
            self.containerView.addSubview(invFromMap.view)
            invFromMap.didMove(toParent: self)
            self.addChild(invFromMap)
            self.invFromMap.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
        }
        else if segment.selectedSegmentIndex == 1{
            self.addChild(invFromCollection)
            self.containerView.addSubview(invFromCollection.view)
            invFromCollection.didMove(toParent: self)
            self.addChild(invFromCollection)
            self.invFromCollection.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
        }
    }
    
    @objc func tapButton(){
        var params : [String : Any] = [:]
        var location : [String : Any] = [:]
        if hangLocationID != "" {
            params = ["title" : hangTitle
                ,"location" : hangLocationID
                , "startDate" : hangStartDate
                , "endDate" : hangEndDate
                , "isPublic" : hangPublic
                , "requiresRequests" : hangWithRequest
                , "description" : hangDesc
                , "interests" : hangInterests
                , "max" : hangMax
                , "gender" : hangGender
                , "invites" : invitedIDsArray ] as! [String : Any]
        }
        else{
            location = ["title" : locationName , "address" : locationAdress ,"lat" : lat,"lng" : long,"placeType" : locationType,"city" : city,"country" : country]
            print(location)
            params = ["title" : hangTitle
                ,"location" : location
                , "startDate" : hangStartDate
                , "endDate" : hangEndDate
                , "isPublic" : hangPublic
                , "requiresRequests" : hangWithRequest
                , "description" : hangDesc
                , "interests" : hangInterests
                , "max" : hangMax
                , "gender" : hangGender
                , "invites" : invitedIDsArray ] as! [String : Any]
        }
        
        if Meteor.meteorClient?.connected == true{
            Meteor.meteorClient?.callMethodName("hangouts.methods.create", parameters: [params], responseCallback: { (response, error) in
                if error != nil{
                    print(error)
                }
                else{
                    print(response)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        }
        else{
            print("not connected")
        }
    }
    
}


extension UIViewController {

    func childRemove() {
        removeChild()
    }
}
