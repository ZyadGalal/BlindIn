//
//  MZOffersDetailsViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import ObjectiveDDP

class MZOffersDetailsViewController: UIViewController {
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var offerNameLabel: UILabel!
    @IBOutlet weak var offerDetailsTextView: UITextView!
    @IBOutlet weak var getOfferButton: UIButton!
    
    var offerClaims = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var offerID = ""
    
    var offerTitle = ""
    var offerDesc = ""
    var Image = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        offerImageView.kf.indicatorType = .activity
        offerImageView.kf.setImage(with: URL(string: Image as! String))
        offerNameLabel.text = offerTitle
        offerDetailsTextView.text = offerDesc
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ClaimOfferButtonClicked(_ sender: Any) {
        
        if Meteor.meteorClient?.connected == true{
            Meteor.meteorClient?.callMethodName("offers.methods.claim", parameters: [["_id" : offerID]], responseCallback: { (response, error) in
                if error != nil{
                    print(error)
                }
                else{
                    print(response!["result"]!)
                    let result = (response!["result"]!)
                    let alert = UIAlertController(title: "Congrates 🎉", message: "Your Code is \(result)" , preferredStyle: UIAlertController.Style.alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        
                        // Code in this block will trigger when OK button tapped.
                        print("Ok button tapped");
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    alert.addAction(OKAction)

                    //alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        else{
            print("not connected")
        }
        
    }
    
}
