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
   
    @IBOutlet weak var membersCountLabel: UILabel!
    @IBOutlet weak var imagesDarkView: UIView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var firstImageView: UIImageView!
    
    var isFloatyAppear : Int = 0
    var floaty = Floaty()
    var hangoutId = ""
    var hangoutInfo = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var interests = M13MutableOrderedDictionary<NSCopying, AnyObject>()
    var users = M13MutableOrderedDictionary<NSCopying, AnyObject>()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        NotificationCenter.default.addObserver(self, selector: #selector(getHangoutInfo), name: NSNotification.Name("interests_added"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(updateHangoutInfo), name: NSNotification.Name("interests_changed"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(removeHangoutInfo), name: NSNotification.Name("interests_removed"),object : nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getHangoutInfo), name: NSNotification.Name("users_added"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(updateHangoutInfo), name: NSNotification.Name("users_changed"),object : nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(removeHangoutInfo), name: NSNotification.Name("users_removed"),object : nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        Meteor.meteorClient?.removeSubscription("hangouts.single")
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func joinButtonClicked(_ sender: Any) {
        joinHang(hangout: hangoutId)
    }
    func joinHang(hangout : String){
        if Meteor.meteorClient?.connected == true{
            Meteor.meteorClient?.callMethodName("hangouts.methods.join", parameters: [["hangoutId":hangout]], responseCallback: { (response, error) in
                if error != nil{
                    print(error!)
                }
                else{
                    print(response!)
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
    @objc func getHangoutInfo ()
    {
        hangoutInfo = Meteor.meteorClient?.collections["hangouts"] as! M13MutableOrderedDictionary
        if Meteor.meteorClient?.collections["interests"] != nil{
        interests = Meteor.meteorClient?.collections["interests"] as! M13MutableOrderedDictionary
        }
        if Meteor.meteorClient?.collections["users"] != nil{
            users = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
        }
        //print(interests)
        //print(hangoutInfo)
        updateInfo()
    }
    @objc func updateHangoutInfo ()
    {
        hangoutInfo = Meteor.meteorClient?.collections["hangouts"] as! M13MutableOrderedDictionary
        if Meteor.meteorClient?.collections["interests"] != nil{
            interests = Meteor.meteorClient?.collections["interests"] as! M13MutableOrderedDictionary
        }
        if Meteor.meteorClient?.collections["users"] != nil{
            users = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
        }
        //print(hangoutInfo)
        updateInfo()
    }
    @objc func removeHangoutInfo ()
    {
        hangoutInfo = Meteor.meteorClient?.collections["hangouts"] as! M13MutableOrderedDictionary
        if Meteor.meteorClient?.collections["interests"] != nil{
            interests = Meteor.meteorClient?.collections["interests"] as! M13MutableOrderedDictionary
        }
        if Meteor.meteorClient?.collections["users"] != nil{
            users = Meteor.meteorClient?.collections["users"] as! M13MutableOrderedDictionary
        }
        //print(hangoutInfo)
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
            locationLabel.text = current["locationTitle"] as? String
            durationLabel.text = "\(current["startDate"] as! String) : \(current["endDate"] as! String)"
            hangoutImageView.kf.setImage(with: URL(string: current["image"] as! String))
            hangoutMembersCountLabel.text = "\(current["membersCount"] as! Int) joined"
            var interestsString = ""
            if Meteor.meteorClient?.collections["interests"] != nil{
                for inter in current["interests"] as! [String]{
                    for index in 0..<Int(interests.count) {
                        let interest = interests.object(at: UInt(index)) as! [String : Any]
                        if inter == interest["_id"] as? String{
                            interestsString.append("\(interest["title"] as! String) ,")
                            break
                        }
                        
                    }
                }
                interestsLabel.text = interestsString

            }
         if Meteor.meteorClient?.collections["users"] != nil{
            print("users ================> \(users.count)")
                let members = current["members"] as! [String]
            if members.count >= 1{
                let userImage = getUserImage(userId: members[0])
                if userImage != ""{
                    firstImageView.kf.setImage(with: URL(string: userImage)!)
                }
            }
            if members.count >= 2{
                let userImage = getUserImage(userId: members[1])
                if userImage != ""{
                    secondImageView.kf.setImage(with: URL(string: userImage)!)
                }
                
            }
            if members.count >= 3{
                let userImage = getUserImage(userId: members[2])
                if userImage != ""{
                    thirdImageView.kf.setImage(with: URL(string: userImage)!)
                }
                
            }
            if members.count >= 4{
                imagesDarkView.isHidden = false
                membersCountLabel.text = "\(members.count - 3)"
            }
            }
            let joinedMembers = current["members"] as! [String]
            for member in joinedMembers{
                if member == Meteor.meteorClient?.userId!{
                    joinButton.isHidden = true
                    sharingButton.isHidden = false
                    return
                }
                else{
                    joinButton.isHidden = false
                    sharingButton.isHidden = true
                }
            }
            if isFloatyAppear == 0{
            let chatStatus = current["chatStatus"] as! Int
            if chatStatus == 1{
                self.setupFloatActionButton(status: 1)
            }
            else{
                self.setupFloatActionButton(status: 0)
            }
            }
        }
    }
    func getUserImage (userId : String) -> String{
        if Meteor.meteorClient?.collections["users"] != nil{
            for index in 0..<Int(users.count){
                let user = users.object(at: UInt(index))
                if userId == user["_id"] as! String{
                    let profile = user["profile"] as! [String : Any]
                    return profile["image"] as! String
                }
            }
        }
        return ""
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
    func setupFloatActionButton (status : Int){
        
        floaty.hasShadow = true
        floaty.addItem("Posts", icon: UIImage(named: "post")) { (item) in
            let vc = UIStoryboard(name: "HangoutProfile", bundle: nil).instantiateViewController(withIdentifier: "ZGHangoutProfilePostsViewController") as! ZGHangoutProfilePostsViewController
            vc.hangoutId = self.hangoutId
            self.navigationController?.pushViewController(vc, animated: true)
            self.floaty.close()
        }
        if status == 1{
            floaty.addItem("Chat", icon: UIImage(named: "chat")) { (item) in
                let vc = UIStoryboard(name: "HangoutProfile", bundle: nil).instantiateViewController(withIdentifier: "ZGHangoutProfileChatViewController") as! ZGHangoutProfileChatViewController
                vc.hangoutId = self.hangoutId
                self.navigationController?.pushViewController(vc, animated: true)
                self.floaty.close()
            }
        }
        floaty.fabDelegate = self
        floaty.openAnimationType = .fade
        self.view.addSubview(floaty)
        isFloatyAppear = 1
    }
    
    @IBAction func inviteBestieButtonClicked(_ sender: Any) {
        let vc = UIStoryboard(name: "HangoutProfile", bundle: nil).instantiateViewController(withIdentifier: "ZGInviteBestiesViewController") as! ZGInviteBestiesViewController
        vc.hangoutId = self.hangoutId
        self.navigationController?.pushViewController(vc, animated: true)
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
