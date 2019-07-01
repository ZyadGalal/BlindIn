//
//  MZEventHistoryViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZEventHistoryViewController: UIViewController {

    @IBOutlet weak var segmentInsertView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    //segment control
    let buttonBar = UIView()
    let segmentedControl = UISegmentedControl()
    var segmentIndex : Int = 0
    
    let past = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZPastEventViewController") as! MZPastEventViewController
    let Upcoming = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZUpcomingEventViewController") as! MZUpcomingEventViewController

    
    override func viewDidLoad() {
        super.viewDidLoad()

        SegmentControl()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    func SegmentControl()
    {
        segmentInsertView.layer.shadowOpacity = 0.3
        segmentInsertView.layer.shadowRadius = 2.0
        segmentInsertView.layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
        segmentInsertView.layer.masksToBounds = false
        // Add segments
        
        self.segmentedControl.insertSegment(withTitle: "Past", at: 0, animated: true)
        self.segmentedControl.insertSegment(withTitle: "Upcoming", at: 1, animated: true)
        
        // First segment is selected by default
        self.segmentedControl.selectedSegmentIndex = 0
        self.addChild(past)
        self.containerView.addSubview(past.view)
        past.didMove(toParent: self)
        self.addChild(past)
        self.past.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
        
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
            NSAttributedString.Key.foregroundColor: UIColor(red: 61/255, green: 101/255, blue: 255/255, alpha: 1.0)
            ], for: .selected)
        
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor(red: 61/255, green: 101/255, blue: 255/255, alpha: 1.0)
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
        childRemove()
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
        }
        if segmentedControl.selectedSegmentIndex == 0{
            print("0")
            self.addChild(past)
            self.containerView.addSubview(past.view)
            past.didMove(toParent: self)
            self.addChild(past)
            self.past.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
        }
        else {
            print("1")
            self.addChild(Upcoming)
            self.containerView.addSubview(Upcoming.view)
            Upcoming.didMove(toParent: self)
            self.addChild(Upcoming)
            self.Upcoming.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
        }
        segmentIndex = segmentedControl.selectedSegmentIndex
        
    }

}
