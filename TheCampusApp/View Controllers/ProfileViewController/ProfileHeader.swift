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
    
    // MARK:- UI Elements
    
    // User
    let profilePic: RoundImageView = {
        let imageView = RoundImageView()
        imageView.image = UIImage(named: "Avatar")
        return imageView
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = UserData.shared.name ?? ""
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    // Stats
    let followingStatLabel = UILabel()
    let followersStatLabel = UILabel()
    let likesStatLabel = UILabel()
    let questionsStatLabel = UILabel()
    let answersStatLabel = UILabel()
    let somethingStatLabel = UILabel()
    
    // Stack
    var statStack1: UIStackView!
    var statStack2: UIStackView!
    
    // Settings
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        return button
    }()
    
    // Seperator
    let headerSeperator = UIView()
    
    // MARK:- Initializers
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupColors()
        addStatsText()
        setupProfilePic()
        setupNameLabel()
        setupStats()
        setupEditProfileButton()
        addSeperator()
    }
    
    // MARK:- Setup
    func setupColors(){
        editProfileButton.tintColor = selectedTheme.primaryTextColor
        editProfileButton.layer.borderColor = selectedTheme.primaryTextColor.cgColor
        nameLabel.textColor = selectedTheme.primaryTextColor
        headerSeperator.backgroundColor = selectedTheme.secondaryTextColor
    }
    
    func addStatsText(){
        let data = UserData.shared
        followingStatLabel.attributedText = getAttributedText(for: "Following", with: data.followingCount ?? 0)
        followersStatLabel.attributedText = getAttributedText(for: "Followers", with: data.followerCount ?? 0)
        likesStatLabel.attributedText = getAttributedText(for: "Likes", with: data.likesCount ?? 0)
        questionsStatLabel.attributedText = getAttributedText(for: "Questions", with: data.questionsCount ?? 0)
        answersStatLabel.attributedText = getAttributedText(for: "Answers", with: data.answersCount ?? 0)
        somethingStatLabel.attributedText = getAttributedText(for: "Something", with: 0)
    }
    
    func setupProfilePic(){
        let imagePadding = frame.height * 0.08
        addSubview(profilePic)
        profilePic.anchor(top: topAnchor, left: leadingAnchor, paddingTop: imagePadding, paddingLeft: imagePadding)
        profilePic.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.60).isActive = true
        profilePic.widthAnchor.constraint(equalTo: profilePic.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setupNameLabel(){
        addSubview(nameLabel)
        nameLabel.centerX(profilePic.centerXAnchor)
        nameLabel.anchor(top: profilePic.bottomAnchor, bottom: bottomAnchor)
    }
    
    func setupStats(){
        let padding: CGFloat = 10
        
        [followingStatLabel, followersStatLabel, likesStatLabel, questionsStatLabel, answersStatLabel, somethingStatLabel].forEach { (label) in
            label.textAlignment = .center
            label.numberOfLines = 0
        }
        
        // StatStack1
        statStack1 = UIStackView(arrangedSubviews: [followingStatLabel, followersStatLabel, likesStatLabel])
        statStack1.axis = .horizontal
        statStack1.distribution = .fillEqually
        addSubview(statStack1)
        statStack1.anchor(top: profilePic.topAnchor, left: profilePic.trailingAnchor, right: trailingAnchor, paddingTop: padding, paddingRight: 5)
        
        // StatStack2
        statStack2 = UIStackView(arrangedSubviews: [questionsStatLabel, answersStatLabel, somethingStatLabel])
        statStack2.axis = .horizontal
        statStack2.distribution = .fillEqually
        addSubview(statStack2)
        statStack2.anchor(bottom: profilePic.bottomAnchor, left: profilePic.trailingAnchor, right: trailingAnchor, paddingBottom: padding, paddingRight: 5)
    }
    
    func setupEditProfileButton(){
        addSubview(editProfileButton)
        editProfileButton.centerY(nameLabel.centerYAnchor)
        editProfileButton.anchor(left: nameLabel.trailingAnchor, right: trailingAnchor, paddingLeft: 20, paddingRight: 20)
    }
    
    func addSeperator(){
        addSubview(headerSeperator)
        headerSeperator.anchor(bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingBottom: 0, height: 2)
    }
    
    private func getAttributedText(for stat: String, with count: Int) -> NSMutableAttributedString{
        let attributedText = NSMutableAttributedString(string: "\(count)", attributes: [
            .font : UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor : selectedTheme.primaryTextColor
            ])
        
        attributedText.append(NSAttributedString(string: "\n\(stat)", attributes: [
            .foregroundColor: selectedTheme.secondaryTextColor,
            .font : UIFont.systemFont(ofSize: 14)
            ]))
        
        return attributedText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RoundImageView: UIImageView{
    
    init(){
        super.init(frame: .zero)
        self.clipsToBounds = true
    }
    
    override var bounds: CGRect {
        didSet {
            layer.cornerRadius = bounds.height/2
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
