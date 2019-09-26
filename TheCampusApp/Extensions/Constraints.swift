//
//  Constraints.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 22/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

extension UIView{
    func anchor(top: NSLayoutYAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = nil, paddingBottom: CGFloat? = nil, paddingLeft: CGFloat? = nil, paddingRight: CGFloat? = nil, height: CGFloat? = nil, width: CGFloat? = nil){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top{
            self.topAnchor.constraint(equalTo: top, constant: paddingTop ?? 0).isActive = true
        }
        if let bottom = bottom{
            self.bottomAnchor.constraint(equalTo: bottom, constant: -1 * (paddingBottom ?? 0)).isActive = true
        }
        if let left = left{
            self.leadingAnchor.constraint(equalTo: left, constant: paddingLeft ?? 0).isActive = true
        }
        if let right = right{
            self.trailingAnchor.constraint(equalTo: right, constant: -1*(paddingRight ?? 0)).isActive = true
        }
        if let height = height{
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = width{
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    func centerX(_ centerAnchor: NSLayoutXAxisAnchor, shiftBy: CGFloat = 0){
        self.centerXAnchor.constraint(equalTo: centerAnchor, constant: shiftBy).isActive = true
    }
    
    func centerY(_ centerAnchor: NSLayoutYAxisAnchor, shiftBy: CGFloat = 0){
        self.centerYAnchor.constraint(equalTo: centerAnchor, constant: shiftBy).isActive = true
    }
}
