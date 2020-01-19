//
//  UIButton.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 11/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit

extension UIButton{
//    func centerVertically() {
//        let spacing: CGFloat = 6.0
//        let imageSize = CGSize(width: 35, height: 35)// self.imageView!.frame.size
//        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
//        let titleSize =  CGSize(width: 28, height: 19) // self.titleLabel!.frame.size
//        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
//    }
}

class VerticalButton: UIButton{
    let spacing: CGFloat = 4
    
    func centerVertically() {
        let imageSize = imageView!.frame.size
        let textSize = titleLabel!.frame.size
        let titleYOff = -(spacing + imageSize.height + textSize.height/2)
        let imageYOff = -(textSize.height/2)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: titleYOff, right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: imageYOff, left: 0, bottom: 0, right: -textSize.width)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerVertically()
    }
}
