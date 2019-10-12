//
//  Constants.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 28/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

let blueColorDark = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
let blueColorFaint = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)

let postSectionVerticalPadding : CGFloat = 10
let postCellSidePadding: CGFloat = 10
let postCellHeight: CGFloat = 200

let questionFont = UIFont.systemFont(ofSize: 16, weight: .medium)
let answerFont = UIFont.systemFont(ofSize: 14, weight: .light)

let numberOfLinesInQuestion = 2
let numberOfLinesInAnswer = 3

let textFieldBackgroundColor = UIColor(white: 0, alpha: 0.05)
let textFieldTextColor = UIColor.black
let textFieldPlaceholderColor = UIColor(white: 0.15, alpha: 0.6)

// Tip for asking question
func tipAttributedString()->NSMutableAttributedString{
    let attributedText = NSMutableAttributedString(string: "Tips on getting good answers quickly\n", attributes: [
        .font: UIFont.systemFont(ofSize: 16, weight: .bold),
        .foregroundColor: selectedTheme.primaryTextColor,
        .baselineOffset: 5
    ])
    
    // Image Bullet point
    let imageAttachment = NSTextAttachment()
    imageAttachment.image = UIImage(named: "TickMark")?.resizeImage(size: CGSize(width: 20, height: 20)).with(color: selectedAccentColor.primaryColor)
    let imageString = NSAttributedString(attachment: imageAttachment)
    
    // Actual Tips
    let tips = [
        " Make sure your question hasn't been asked already\n",
        " Keep your question short and to the point\n",
        " Double Check grammer and spelling\n"
    ]
    let tipAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: selectedTheme.primaryPlaceholderColor,
        .baselineOffset: 3
    ]
    
    tips.forEach({(point) in
        attributedText.append(imageString)
        attributedText.append(NSAttributedString(string: point, attributes: tipAttributes))
    })
    
    return attributedText
}

let changeThemeKey = "changeThemeKey"
let changeAccentColorKey = "changeAccentColorKey"
let glyphSize = CGSize(width: 30, height: 30)
let iconSize = CGSize(width: 30, height: 30)

let themes = [lightTheme, darkTheme]
var selectedTheme: Theme = lightTheme // darkTheme
var selectedAccentColor: AccentColor = blueAccentColor

