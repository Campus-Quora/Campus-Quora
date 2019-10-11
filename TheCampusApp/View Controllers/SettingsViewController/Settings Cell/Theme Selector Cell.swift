//
//  PopUpViewCell.swift
//  Music App
//
//  Created by Yogesh Kumar on 29/04/19.
//  Copyright © 2019 Yogesh Kumar. All rights reserved.
//

import UIKit

let optionOffsetFromLeft: CGFloat = 60
let circleOffsetFromOption: CGFloat = 10
let outerCircleRadius: CGFloat = 10
let innerCircleRadius: CGFloat = 5
let lineWidth: CGFloat = 3


class OptionSelectorCell: UICollectionViewCell{
    
    let option = UILabel()
    let outerCircle = CAShapeLayer()
    let insideCircle = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupLayer(layer: CAShapeLayer, radius: CGFloat){
        let x: CGFloat = optionOffsetFromLeft - circleOffsetFromOption - lineWidth - outerCircleRadius
        let circularPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.position = CGPoint(x: x, y: frame.height/2)
        self.layer.addSublayer(layer)
    }
    
    func setupCell(data: String, selected: Bool){
        // Setup Text Button
        setUpTextButton(with: data)
        
        // Setup Outer circle
        if selected {
            setupOuterCircle(color: selectedAccentColor.primaryColor)
            setupinnerCircle()
        }
            
        else{
            // Setup Inner Circle
            destroyInnerCircleIfPresent()
            setupOuterCircle(color: selectedAccentColor.secondaryColor)
        }
    }
    
    func setUpTextButton(with data: String){
        option.text = data
        option.font = UIFont(name: "Avenir-Heavy", size: 18)
        option.textColor = selectedTheme.secondaryColor 
        option.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(option)
        NSLayoutConstraint.activate([
            option.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            option.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: optionOffsetFromLeft),
            option.topAnchor.constraint(equalTo: self.topAnchor),
            option.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
    func setupOuterCircle(color: UIColor){
        setupLayer(layer: outerCircle, radius: outerCircleRadius)
        outerCircle.strokeColor = color.cgColor
        outerCircle.lineWidth = lineWidth
        outerCircle.fillColor = UIColor.clear.cgColor
    }
    
    func setupinnerCircle(){
        setupLayer(layer: insideCircle, radius: innerCircleRadius)
        insideCircle.fillColor = selectedAccentColor.primaryColor.cgColor
    }
    
    func destroyInnerCircleIfPresent(){
        insideCircle.fillColor = UIColor.clear.cgColor
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
