//
//  SettingsCell.swift
//  Music App
//
//  Created by Yogesh Kumar on 27/04/19.
//  Copyright © 2019 Yogesh Kumar. All rights reserved.
//

//import UIKit

//class SettingsCell: UITableViewCell{
//
//    var nameLabel = UILabel(frame: .zero)
//    var descriptionLabel = UILabel(frame: .zero)
//    var cellType: SettingsCellType!
//
//    func setupCell(data: Setting){
//        setupNameLabel(name: data.name)
//        setUpDescriptionLabel(description: data.description)
//        cellType = data.cellType
//    }
//
//    func setupNameLabel(name: String){
//        nameLabel.text = name
//        nameLabel.font = UIFont(name: "Avenir-Heavy", size: 18)
//        nameLabel.textColor = selectedTheme.textColor
//
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(nameLabel)
//        NSLayoutConstraint.activate(
//        [  nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
//           nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//           nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5)
//        ])
//    }
//
//    func setUpDescriptionLabel(description: String){
//        descriptionLabel.text = description
//        descriptionLabel.font = UIFont(name: "Avenir-Medium ", size: 16)
//        descriptionLabel.textColor = secondaryColor
//        descriptionLabel.numberOfLines = 0
//
//        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(descriptionLabel)
//        NSLayoutConstraint.activate(
//            [  descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:-10),
//               descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//               descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0)
//            ])
//    }
//
//    func handleSelection(){
//        switch(cellType){
//            case .popup?  : handlePopup()
//            case .color?  : handleColor()
//            case .toggle? : handleToggle()
//            case .none    : break
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//
//extension SettingsCell{
//    func handlePopup(){
//
//    }
//
//    func handleColor(){
//
//    }
//
//    func handleToggle(){
//
//    }
//}
