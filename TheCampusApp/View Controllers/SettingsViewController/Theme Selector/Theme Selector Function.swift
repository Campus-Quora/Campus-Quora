//
//  Theme Selector Function.swift
//  Music App
//
//  Created by Yogesh Kumar on 29/04/19.
//  Copyright © 2019 Yogesh Kumar. All rights reserved.
//

import UIKit

//extension SettingFunctions{
//    func themeFunction(){
//        setupDimBG()
//        var items = [String]()
//        for theme in themes{
//            items.append(theme.themeName)
//        }
//        let selectedOption = selectedTheme.themeName
//        let changeThemeName = Notification.Name(rawValue: changeThemeKey)
//        let popupView = OptionSelector(headerText: "General Theme", itemsToDisplay: items, selectedOption: selectedOption!){
//            (newThemeIndex,selectedThemeName) in
//            if(themes[newThemeIndex].themeName != selectedThemeName){
//                selectedTheme = themes[newThemeIndex]
//                settings[0].list[0].description = selectedTheme.themeName
//                applyTheme()
//                NotificationCenter.default.post(name: changeThemeName, object: nil)
//            }
//            NotificationCenter.default.post(name: self.dismissPopupName, object: nil)
//            self.handleDismissTheme()
//        }
//        window?.addSubview(popupView)
//    }
//}
