//
//  AccentColorCell.swift
//  Music App
//
//  Created by Yogesh Kumar on 29/04/19.
//  Copyright © 2019 Yogesh Kumar. All rights reserved.
//

import UIKit

let colorCellborderWidth: CGFloat = 5
let colorCellSize: CGFloat = 40

class AccentColorPickerCell: UICollectionViewCell{
    
    let color =  UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(color)
        color.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            color.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            color.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            color.topAnchor.constraint(equalTo: self.topAnchor),
            color.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        color.layer.cornerRadius = frame.width/2
    }
    
    func setupCell(data: UIColor, selected: Bool){
        color.backgroundColor = data
        if(selected){
            color.layer.borderWidth = colorCellborderWidth
            color.layer.borderColor = selectedTheme.textColor.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
