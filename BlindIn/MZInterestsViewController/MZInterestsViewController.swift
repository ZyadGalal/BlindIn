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
        self.navigationItem.title = "Interests"
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let cell =  interestCollectionView.dequeueReusableCell(withReuseIdentifier: "interestsCell", for: indexPath) as! MZInterestsCollectionViewCell
        cell.interestLabel.text = "FORTNITE"
        cell.interestImageView.image = UIImage(named: "1")
        cell.interestImageView.isUserInteractionEnabled = true
        cell.interestImageView.addGestureRecognizer(tapGestureRecognizer)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/3)  , height: 150)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        tappedImage.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
    }
}

