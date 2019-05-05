//
//  ZGNewsFeedViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/4/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class ZGNewsFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        putProfileBtnInNavigationController()
    }
    
    func putProfileBtnInNavigationController ()
    {
        let profileButton : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        profileButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileButton.layer.masksToBounds = true
        profileButton.layer.cornerRadius = 20
        profileButton.setImage(UIImage(named: "1"), for: .normal)
        profileButton.imageView?.contentMode = .scaleToFill
        profileButton.addTarget(self, action: #selector(ProfileButtonClicked), for: .touchUpInside)
        let navigationBtn = UIBarButtonItem(customView: profileButton)
        self.navigationItem.setRightBarButton(navigationBtn, animated: false)
    }
    @objc func ProfileButtonClicked ()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZGUserProfileViewController") as! ZGUserProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ZGNewsFeedViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "news") as! ZGNewsFeedTableViewCell
        cell.userImageView.image = UIImage(named: "1")
        cell.userNameLable.text = "Zyad Galal"
        cell.dateLabel.text = "5 min"
        cell.hangImageView.image = UIImage(named: "1")
        cell.likeCountLabel.text = "55555"
        cell.commentCountLabel.text = "10"
        cell.hangDescriptionLabel.text = "hi , i'm zyad mahmoud galal , i'm iOS Developer , from new damietta . in mansoura university"
        return cell
    }
}
