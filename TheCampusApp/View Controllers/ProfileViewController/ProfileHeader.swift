//
//  Header.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 27/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

class ProfileHeader: UICollectionViewCell{
    // Constants
    var height: CGFloat = 0
    
    // UI Elements
    let profilePic: RoundImageView = {
        let imageView = RoundImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Avatar")
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Yogesh Kumar"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupProfilePic()
        setupNameLabel()
    }
    
    func setupProfilePic(){
        let imagePadding = frame.height * 0.1
        addSubview(profilePic)
        profilePic.anchor(top: topAnchor, left: leadingAnchor, paddingTop: imagePadding, paddingLeft: imagePadding)
        profilePic.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65).isActive = true
        profilePic.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65).isActive = true
    }
    
    func setupNameLabel(){
        addSubview(nameLabel)
        nameLabel.centerX(profilePic.centerXAnchor)
        nameLabel.anchor(top: profilePic.bottomAnchor, bottom: bottomAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RoundImageView: UIImageView{
    override var bounds: CGRect {
        didSet {
            layer.cornerRadius = bounds.height/2
        }
    }
}
