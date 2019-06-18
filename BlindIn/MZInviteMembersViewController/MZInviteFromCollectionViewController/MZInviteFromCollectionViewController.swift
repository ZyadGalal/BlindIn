//
//  MZInviteFromCollectionViewController.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/2/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import UIKit

class MZInviteFromCollectionViewController: UIViewController {

    @IBOutlet weak var nearbyMemberCollectionView: UICollectionView!
    @IBOutlet weak var bestiesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}

extension MZInviteFromCollectionViewController : UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var return_Value = 0
        if collectionView == nearbyMemberCollectionView{
            return_Value = 6
        }
        else if collectionView == bestiesCollectionView{
            return_Value = 2
        }
        return return_Value
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        if collectionView == nearbyMemberCollectionView {
            // Place content into hashtag cells
            let nearbyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MZNearbyMemberCollectionViewCell", for: indexPath) as! MZNearbyMemberCollectionViewCell
            nearbyCell.nearbyMemberNameLabel.text = "Momen"
            nearbyCell.nearbyMemberImageView.isUserInteractionEnabled = true
            nearbyCell.nearbyMemberImageView.addGestureRecognizer(tapGestureRecognizer)
            return nearbyCell
        } else if collectionView == bestiesCollectionView {
            // Place content in creators cell
            let bestieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MZBestiesCollectionViewCell", for: indexPath) as! MZBestiesCollectionViewCell
            bestieCell.bestieNameLabel.text = "Mo2a"
            bestieCell.bestieImageView.isUserInteractionEnabled = true
            bestieCell.bestieImageView.addGestureRecognizer(tapGestureRecognizer)
            return bestieCell
        } else {
            preconditionFailure("Unknown collection view!")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/4)  , height: 100)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if tappedImage.borderColor == UIColor(red: 111/255.0, green: 113/255.0, blue: 121/255.0, alpha: 1.0) as UIColor{
            tappedImage.borderColor = UIColor(red:0/255.0, green:122/255.0, blue:255/255.0, alpha:1.00)
        }
        else {
            tappedImage.borderColor = UIColor(red: 111/255.0, green: 113/255.0, blue: 121/255.0, alpha: 1.0)
        }
    }
    
    
}
