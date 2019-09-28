//
//  String.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 28/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

extension String{
    func findHeight(size: CGSize, attributes: [NSAttributedString.Key: Any])->CGFloat{
        let rect = NSString(string: self).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.height
    }
    
    static func findSingleLineHeight(width: CGFloat, attributes: [NSAttributedString.Key: Any])->CGFloat{
        let rect = NSString(string: " ").boundingRect(with: CGSize(width: width, height: 1000), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.height
    }
}
