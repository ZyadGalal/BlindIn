//
//  CustomMarkerShape.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/17/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class CircularMarkerShape : UIView {
    var img: String!
    var imgBorderColor: UIColor!
    
    init(frame: CGRect, image: String, borderColor: UIColor) {
        super.init(frame: frame)
        self.img=image
        self.imgBorderColor=borderColor
        setupViews()
    }
    
    func setupViews() {
        var imgView = UIImageView()
        imgView.frame=CGRect(x: 0, y: 0, width: 50, height: 50)
        imgView.layer.cornerRadius = 25
        imgView.layer.borderColor=imgBorderColor?.cgColor
        imgView.layer.borderWidth=4
        imgView.clipsToBounds=true
        DispatchQueue.main.async {
            imgView.kf.indicatorType = .activity
            imgView.kf.setImage(with: URL(string: self.img!)!)
        }
        
        self.addSubview(imgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
