//
//  ZGPostsContainerViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class ZGPostsContainerViewController: UIViewController {

    @IBOutlet weak var segmentInsertView: UIView!
    @IBOutlet weak var containerView: UIView!

    let posts = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZGNewsFeedViewController") as! ZGNewsFeedViewController
    let explore	 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExploreViewController") as! ExploreViewController
    //segment control
    let buttonBar = UIView()
    let segmentedControl = UISegmentedControl()
    var segmentIndex : Int = 0
    func SegmentControl()
    {
        segmentInsertView.layer.shadowOpacity = 0.3
        segmentInsertView.layer.shadowRadius = 2.0
        segmentInsertView.layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
        segmentInsertView.layer.masksToBounds = false
        // Add segments
        
        self.segmentedControl.insertSegment(withTitle: "Posts", at: 0, animated: true)
        self.segmentedControl.insertSegment(withTitle: "Explore", at: 1, animated: true)
        
        // First segment is selected by default
        self.segmentedControl.selectedSegmentIndex = 0
        
        // This needs to be false since we are using auto layout constraints
        self.segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        // Add the segmented control to the container view
        self.segmentInsertView.addSubview(self.segmentedControl)
        // Constrain the segmented control to the top of the container view
        self.segmentedControl.topAnchor.constraint(equalTo:  segmentInsertView.topAnchor).isActive = true
        // Constrain the segmented control width to be equal to the container view width
        self.segmentedControl.widthAnchor.constraint(equalTo:  segmentInsertView.widthAnchor).isActive = true
        // Constraining the height of the segmented control to an arbitrarily chosen value
        self.segmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //clear backgroud color
        self.segmentedControl.backgroundColor = .clear
        self.segmentedControl.tintColor = .clear
        //change color
        self.segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        self.segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor(red: 61/255, green: 101/255, blue: 255/255, alpha: 1)
            ], for: .selected)
        
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor(red: 61/255, green: 101/255, blue: 255/255, alpha: 1)
        segmentInsertView.addSubview(buttonBar)
        
        buttonBar.topAnchor.constraint(equalTo: segmentInsertView.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
        // Constrain the button bar to the left side of the segmented control
        buttonBar.leftAnchor.constraint(equalTo: segmentInsertView.leftAnchor).isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
        buttonBar.widthAnchor.constraint(equalTo: segmentInsertView.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        //animation
        self.segmentedControl.addTarget(responds, action: #selector(segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
        }
        segmentIndex = segmentedControl.selectedSegmentIndex
        removeChildController()
        if segmentIndex == 0{
            self.addChild(posts)
            self.containerView.addSubview(posts.view)
            posts.didMove(toParent: self)
            self.posts.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
        }
        else if segmentIndex == 1{
            self.addChild(explore)
            self.containerView.addSubview(explore.view)
            explore.didMove(toParent: self)
            self.explore.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SegmentControl()
        self.addChild(posts)
        self.containerView.addSubview(posts.view)
        posts.didMove(toParent: self)
        self.posts.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
    }


}

extension UIViewController {
    
    func removeChildController() {
        self.children.forEach {
            $0.didMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
}
