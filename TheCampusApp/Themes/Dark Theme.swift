//
//  Dark Theme.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 11/10/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

let darkTheme = Theme.init(
    name: "Dark",
    primaryColor: UIColor(white: 0.15, alpha: 1),
    secondaryColor: UIColor(white: 0.5, alpha: 0.15),
    primaryTextColor: UIColor.white,
    secondaryTextColor: UIColor(white: 0.7, alpha: 1),
    primaryPlaceholderColor: UIColor(white: 0.9, alpha: 0.5),
    secondaryPlaceholderColor: UIColor(white: 0.7, alpha: 0.8),
    unselectedTabBarItemColor: UIColor.gray,
    statusBarStyle: UIStatusBarStyle.lightContent,
    keyboardStyle: UIKeyboardAppearance.dark
)
