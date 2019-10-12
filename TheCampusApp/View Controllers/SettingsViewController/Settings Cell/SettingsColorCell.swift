//
//  SettingsColorCell.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 11/10/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

class SettingsColorCell: UITableViewCell{
    let buttonLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let selectedColor : UIView = {
        let view = UIView()
        let size: CGFloat = 25
        view.heightAnchor.constraint(equalToConstant: size).isActive = true
        view.widthAnchor.constraint(equalToConstant: size).isActive = true
        view.layer.cornerRadius = size/2
        view.backgroundColor = .red
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupColors()
        
        let stack = UIStackView(arrangedSubviews: [buttonLabel, selectedColor])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        buttonLabel.leftAnchor.constraint(equalTo: stack.leftAnchor).isActive = true
        selectedColor.rightAnchor.constraint(equalTo: stack.rightAnchor).isActive = true
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
    }
    
    func setupColors(){
        buttonLabel.textColor = selectedTheme.primaryTextColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
