//
//  MZInterestsViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/16/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZInterestsViewController: UIViewController {
    @IBOutlet weak var interestCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        let vc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "MZHangoutCreationViewController") as! MZHangoutCreationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MZInterestsViewController : UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  interestCollectionView.dequeueReusableCell(withReuseIdentifier: "interestsCell", for: indexPath) as! MZInterestsCollectionViewCell
        
        cell.interestLabel.text = "FORTNITE"
        cell.interestImageView.image = UIImage(named: "1")
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/3)  , height: 150)
    }
}

