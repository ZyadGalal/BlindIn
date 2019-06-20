//
//  CustomMarkerShape.swift
//  BlindIn
//
//  Created by Zyad Galal on 5/17/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import Foundation
import UIKit

class CircularMarkerShape : UIView {
    var img: UIImage!
    var imgBorderColor: UIColor!
    
    init(frame: CGRect, image: UIImage, borderColor: UIColor) {
        super.init(frame: frame)
        self.img=image
        self.imgBorderColor=borderColor
        setupViews()
    }
    
    func setupViews() {
        let imgView = UIImageView(image: img)
        imgView.frame=CGRect(x: 0, y: 0, width: 50, height: 50)
        imgView.layer.cornerRadius = 25
        imgView.layer.borderColor=imgBorderColor?.cgColor
        imgView.layer.borderWidth=4
        imgView.clipsToBounds=true
        
        self.addSubview(imgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
