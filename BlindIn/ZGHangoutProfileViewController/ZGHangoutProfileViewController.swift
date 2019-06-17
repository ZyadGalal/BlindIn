//
//  ZGHangoutProfileViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/17/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit
import Floaty

class ZGHangoutProfileViewController: UIViewController {

    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var sharingButton: UIButton!
    @IBOutlet weak var shadingView: UIView!
    var floaty = Floaty()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFloatActionButton()
        setupShadingView()
        addShadowToButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
        floaty.addItem("Posts", icon: UIImage(named: "like")) { (item) in
            let vc = UIStoryboard(name: "HangoutProfile", bundle: nil).instantiateViewController(withIdentifier: "ZGHangoutProfilePostsViewController") as! ZGHangoutProfilePostsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            self.floaty.close()
        }
        floaty.addItem("Chat", icon: UIImage(named: "like")) { (item) in
            let vc = UIStoryboard(name: "HangoutProfile", bundle: nil).instantiateViewController(withIdentifier: "ZGHangoutProfileChatViewController") as! ZGHangoutProfileChatViewController
            self.navigationController?.pushViewController(vc, animated: true)
            self.floaty.close()
        }
        floaty.fabDelegate = self
        floaty.openAnimationType = .fade
        floaty.animationSpeed = 0.2
        self.view.addSubview(floaty)
    }
}
extension ZGHangoutProfileViewController : FloatyDelegate
{
    func floatyWillOpen(_ floaty: Floaty) {
        print("Floaty Will Open")
    }
    
    func floatyDidOpen(_ floaty: Floaty) {
        print("Floaty Did Open")
    }
    
    func floatyWillClose(_ floaty: Floaty) {
        print("Floaty Will Close")
    }
    
    func floatyDidClose(_ floaty: Floaty) {
        print("Floaty Did Close")
    }
}
