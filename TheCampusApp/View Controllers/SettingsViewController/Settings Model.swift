////
////  Settings Model.swift
////  Music App
////
////  Created by Yogesh Kumar on 12/05/19.
////  Copyright © 2019 Yogesh Kumar. All rights reserved.
////
//
//import UIKit
//
//class Setting{
//    var name: String!
//    var description: String!
//    var cellType: SettingsCellType!
//    var function: ()->Void
//    
//    init(name: String, description: String, cellType: SettingsCellType, function: @escaping ()->Void){
//        self.name = name
//        self.description = description
//        self.cellType = cellType
//        self.function = function
//    }
//}
//
//class SettingsSection{
//    var sectionName: String!
//    var list: [Setting]!
//    
//    init(name: String, settings: [Setting]!){
//        sectionName = name
//        list = settings
//    }
//}
//
//class SettingFunctions{
//    static let shared = SettingFunctions()
//    
//    let window = (UIApplication.shared.delegate?.window)!
//    lazy var dimBG = UIView(frame: (window?.frame)!)
//    let dismissPopupName = Notification.Name(rawValue: dismissPopupKey)
//    
//    func setupDimBG(){
//        window?.addSubview(dimBG)
//        dimBG.backgroundColor = .black
//        dimBG.alpha = 0.5
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDismissTheme))
//        dimBG.addGestureRecognizer(tapGestureRecognizer)
//    }
//    
//    @objc func handleDismissTheme(){
//        NotificationCenter.default.post(name: dismissPopupName, object: nil)
//        dimBG.removeFromSuperview()
//    }
//}
