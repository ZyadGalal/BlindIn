//
//  ZGHangoutProfileViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/17/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import Floaty
import ObjectiveDDP
import Kingfisher
class ZGHangoutProfileViewController: UIViewController {

    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var hangoutDescriptionLabel: UILabel!
    @IBOutlet weak var hangoutMembersCountLabel: UILabel!
    @IBOutlet weak var hangoutTimeLabel: UILabel!
    @IBOutlet weak var hangoutStatusButton: UIButton!
    @IBOutlet weak var hangoutNameLabel: UILabel!
    @IBOutlet weak var hangoutImageView: UIImageView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var sharingButton: UIButton!
    @IBOutlet weak var shadingView: UIView!
    var floaty = Floaty()
    var hangoutId = "fiKztj8jyXpxE4ajt"
    var hangoutInfo = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var interests = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFloatActionButton()
        setupShadingView()
        addShadowToButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        Meteor.meteorClient?.addSubscription("hangouts.single", withParameters: [["hangoutId":hangoutId]])
        NotificationCenter.default.addObserver(self, selector: #selector(getHangoutInfo), name: NSNotification.Name("hangouts_added"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(updateHangoutInfo), name: NSNotification.Name("hangouts_changed"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(removeHangoutInfo), name: NSNotification.Name("hangouts_removed"),object : nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("hangouts.single")
        NotificationCenter.default.removeObserver(self)
    }
    @objc func getHangoutInfo ()
    {
        print(Meteor.meteorClient?.collections)
        hangoutInfo = Meteor.meteorClient?.collections["hangouts"] as! M13MutableOrderedDictionary
        //interests = Meteor.meteorClient?.collections["interests"] as! M13MutableOrderedDictionary
        print(interests)
        print(hangoutInfo)
        updateInfo()
    }
    @objc func updateHangoutInfo ()
    {
        hangoutInfo = Meteor.meteorClient?.collections["hangouts"] as! M13MutableOrderedDictionary
        //interests = Meteor.meteorClient?.collections["interests"] as! M13MutableOrderedDictionary
        print(hangoutInfo)
        updateInfo()
    }
    @objc func removeHangoutInfo ()
    {
        hangoutInfo = Meteor.meteorClient?.collections["hangouts"] as! M13MutableOrderedDictionary
        //interests = Meteor.meteorClient?.collections["interests"] as! M13MutableOrderedDictionary
        print(hangoutInfo)
        updateInfo()
    }
    func updateInfo(){
        if hangoutInfo.count != 0
        {
            let current = hangoutInfo.object(at: UInt(0))
            
            hangoutNameLabel.text = current["title"] as? String
            hangoutStatusButton.setTitle(current["status"] as? String, for: .normal)
            hangoutTimeLabel.text = current["startDate"] as? String
            hangoutDescriptionLabel.text = current["description"] as? String
            genderLabel.text = current["gender"] as? String
            locationLabel.text = current["location"] as? String
            durationLabel.text = "\(current["startDate"] as! String) - \(current["endDate"] as! String)"
            hangoutImageView.kf.setImage(with: URL(string: current["image"] as! String))
            hangoutMembersCountLabel.text = "\(current["membersCount"] as! Int) joined"
            let hangoutInterests = current["interests"] as? [String]
        }
    }
    func addShadowToButton(){
        sharingButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        sharingButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        sharingButton.layer.shadowOpacity = 1.0
        sharingButton.layer.shadowRadius = 0.0
        sharingButton.layer.masksToBounds = false
        
        joinButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        joinButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        joinButton.layer.shadowOpacity = 1.0
        joinButton.layer.shadowRadius = 0.0
        joinButton.layer.masksToBounds = false
    }
    func setupShadingView(){
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [UIColor.black, UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.shadingView.frame.size.width, height: self.shadingView.frame.size.height)
        
        self.shadingView.layer.addSublayer(gradient)
    }
    func setupFloatActionButton (){
        floaty.hasShadow = true
        floaty.addItem("Posts", icon: UIImage(named: "post")) { (item) in
            let vc = UIStoryboard(name: "HangoutProfile", bundle: nil).instantiateViewController(withIdentifier: "ZGHangoutProfilePostsViewController") as! ZGHangoutProfilePostsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            self.floaty.close()
        }
        floaty.addItem("Chat", icon: UIImage(named: "chat")) { (item) in
            let vc = UIStoryboard(name: "HangoutProfile", bundle: nil).instantiateViewController(withIdentifier: "ZGHangoutProfileChatViewController") as! ZGHangoutProfileChatViewController
            self.navigationController?.pushViewController(vc, animated: true)
            self.floaty.close()
        }
        floaty.fabDelegate = self
        floaty.openAnimationType = .fade
        floaty.animationSpeed = 0.2
        self.view.addSubview(floaty)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moreSettingButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { _ in
            let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZHangoutSettingViewController") as! MZHangoutSettingViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Leave", style: .default, handler: { _ in
            //leave networking
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
}
extension ZGHangoutProfileViewController : FloatyDelegate
{
    func floatyWillOpen(_ floaty: Floaty) {
    }
    
    func floatyDidOpen(_ floaty: Floaty) {
    }
    
    func floatyWillClose(_ floaty: Floaty) {
    }
    
    func floatyDidClose(_ floaty: Floaty) {
    }
}
