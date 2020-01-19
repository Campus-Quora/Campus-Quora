//
//  SettingsSelectorCell.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 11/10/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

class SettingsSelectorCell: UITableViewCell{
    let buttonLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let selectedOptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .right
        label.text = selectedTheme.name
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupColors()
        
        let stack = UIStackView(arrangedSubviews: [buttonLabel, selectedOptionLabel])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        buttonLabel.leftAnchor.constraint(equalTo: stack.leftAnchor).isActive = true
        selectedOptionLabel.rightAnchor.constraint(equalTo: stack.rightAnchor).isActive = true
        addSubview(stack)
        stack.fillSuperView(padding: 16)
    
        let name = Notification.Name(changeThemeKey)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeColorTheme), name: name, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didChangeColorTheme(){
        setupColors()
        selectedOptionLabel.text = selectedTheme.name
    }
    
    func setupColors(){
        buttonLabel.textColor = selectedTheme.primaryTextColor
        selectedOptionLabel.textColor = selectedTheme.primaryTextColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
