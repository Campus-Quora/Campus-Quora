//
//  Light Theme.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 11/10/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

let lightTheme = Theme.init(
    name: "Light",
    primaryColor: UIColor.white,
    secondaryColor: UIColor(white: 0.15, alpha: 0.05),
    primaryTextColor: UIColor.black,
    secondaryTextColor: UIColor(white: 0.28, alpha: 0.7),
    primaryPlaceholderColor: UIColor(white: 0.15, alpha: 0.6),
    secondaryPlaceholderColor: UIColor.lightGray,
    unselectedTabBarItemColor: UIColor.gray,
    toolbarColor: UIColor(white: 0.90, alpha: 1),
    statusBarStyle: UIStatusBarStyle.default,
    keyboardStyle: UIKeyboardAppearance.light
)
