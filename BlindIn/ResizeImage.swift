//
//  ResizeImage.swift
//  BlindIn
//
//  Created by Zyad Galal on 6/28/19.
//  Copyright © 2019 Zyad Galal. All rights reserved.
//

import Foundation
import UIKit
class ResizeImage {
   
    static func resizeTo(image : UIImage , maxSize : Double) -> UIImage{
        var width : Double = Double(image.size.width)
        var height : Double = Double(image.size.height)
        
        let imageRatio : Double = width/height
        if imageRatio > 1{
            width = maxSize
            height = width / imageRatio
        }
        else{
            height = maxSize
            width = height * imageRatio
        }
        
        return resizedImageWith(image : image , targetWidth : width , targetHeight : height)
    }
    
    private static func resizedImageWith(image: UIImage, targetWidth : Double , targetHeight : Double) -> UIImage {
        let newSize = CGSize(width: targetWidth, height: targetHeight)
        let rect = CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        image.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
