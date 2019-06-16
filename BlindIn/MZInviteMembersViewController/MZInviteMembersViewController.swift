//
//  MZInviteMembersViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/3/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit


class MZInviteMembersViewController: UIViewController {
    
    let segment: UISegmentedControl = UISegmentedControl(items: ["First", "Second"])
    let invFromCollection = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZInviteFromCollectionViewController") as! MZInviteFromCollectionViewController
    let invFromMap = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZInviteFromMapViewController") as! MZInviteFromMapViewController

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
        print("Done")
    }
    
}


extension UIViewController {

    func childRemove() {
        removeChild()
    }
}
