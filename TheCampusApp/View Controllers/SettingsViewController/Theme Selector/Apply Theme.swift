//
//  Apply Theme.swift
//  Music App
//
//  Created by Yogesh Kumar on 29/04/19.
//  Copyright © 2019 Yogesh Kumar. All rights reserved.
//

import UIKit


func applyTheme(){
    let sharedApplication = UIApplication.shared
    sharedApplication.delegate?.window??.backgroundColor = selectedTheme.primaryColor
    UINavigationBar.appearance().tintColor = selectedAccentColor.primaryColor
    if #available(iOS 11.0, *) {
        UINavigationBar.appearance().largeTitleTextAttributes =
            [   NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 32)!,
                NSAttributedString.Key.foregroundColor : selectedTheme.primaryTextColor
        ]
    } 
}

func changeAccentColor(){
//    UITabBar.appearance().tintColor = selectedAccentColor
}
