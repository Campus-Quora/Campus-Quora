//
//  Header.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 27/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

class ProfileHeader: UITableViewHeaderFooterView{
    // MARK:- UI Elements
    static var profilePicSize = CGSize(width: 100, height: 100)
    let profilePic = RoundImageView()
    let nameLabel = UILabel()
    
    let followingStatLabel = UILabel()
    let followersStatLabel = UILabel()
    let likesStatLabel = UILabel()
    let questionsStatLabel = UILabel()
    let answersStatLabel = UILabel()
    let somethingStatLabel = UILabel()
    
    var statStack1: UIStackView!
    var statStack2: UIStackView!
    var statStack: UIStackView!
    
    let editProfileButton = UIButton()
    
    weak var controller: ProfileViewController?
    
    @objc func setupData(){
        nameLabel.text = UserData.shared.name ?? "Anonymous"
        addStatsText()
    }
    
    // Seperator
    let headerSeperator = UIView()
    
    // MARK:- Initializers
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        setupColors()
        setupData()
        
        var name = Notification.Name(changeThemeKey)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeColorTheme), name: name, object: nil)
        
        name = Notification.Name(updateUserDataKey)
        NotificationCenter.default.addObserver(self, selector: #selector(setupData), name: name, object: nil)
    }
    
    func setupUI(){
        profilePic.image = UIImage(named: "Avatar")?.resizeImage(size: ProfileHeader.profilePicSize)
        profilePic.contentMode = .scaleAspectFit
        
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .center
        
        editProfileButton.setTitle("Edit Profile", for: .normal)
        editProfileButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        editProfileButton.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
        editProfileButton.layer.cornerRadius = 10
//        editProfileButton.layer.borderWidth = 2
        
        [followingStatLabel, followersStatLabel, likesStatLabel, questionsStatLabel, answersStatLabel, somethingStatLabel].forEach { (label) in
            label.textAlignment = .center
            label.numberOfLines = 0
        }
        
        // StatStack1
        statStack1 = UIStackView(arrangedSubviews: [followingStatLabel, followersStatLabel, likesStatLabel])
        statStack1.axis = .horizontal
        statStack1.distribution = .fillEqually
        
        // StatStack2
        statStack2 = UIStackView(arrangedSubviews: [questionsStatLabel, answersStatLabel, somethingStatLabel])
        statStack2.axis = .horizontal
        statStack2.distribution = .fillEqually
        
        statStack = UIStackView(arrangedSubviews: [statStack1, statStack2])
        statStack.axis = .vertical
        statStack.distribution = .fillEqually
    }
    
    func setupConstraints(){
        let stack1 = UIStackView(arrangedSubviews: [profilePic, nameLabel])
        stack1.axis = .vertical
        stack1.distribution = .fillProportionally
        stack1.spacing = 10
        
        let stack2 = UIStackView(arrangedSubviews: [statStack, editProfileButton])
        stack2.axis = .vertical
        stack2.distribution = .fillProportionally
        stack2.spacing = 10
        
        let stack = UIStackView(arrangedSubviews: [stack1, stack2])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 10
        
        addSubview(stack)
        addSubview(headerSeperator)
        profilePic.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profilePic.heightAnchor.constraint(equalTo: profilePic.widthAnchor, multiplier: 1).isActive = true
        editProfileButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stack.fillSuperView(padding: 10)
        
        headerSeperator.anchor(bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor, height: 2)
    }
    
    @objc func didChangeColorTheme(){
        setupColors()
        addStatsText()
    }
    
    // MARK:- Setup
    func setupColors(){
//        editProfileButton.setTitleColor(selectedAccentColor.primaryColor, for: .normal)
//        editProfileButton.layer.borderColor = selectedAccentColor.primaryColor.cgColor
        
        editProfileButton.setTitleColor(selectedTheme.primaryColor, for: .normal)
        editProfileButton.backgroundColor = selectedAccentColor.primaryColor
        
        nameLabel.textColor = selectedTheme.primaryTextColor
        headerSeperator.backgroundColor = selectedTheme.secondaryTextColor
    }
    
    func addStatsText(){
        let data = UserData.shared
        followingStatLabel.attributedText = getAttributedText(for: "Following", with: data.followingCount)
        followersStatLabel.attributedText = getAttributedText(for: "Followers", with: data.followerCount)
        likesStatLabel.attributedText = getAttributedText(for: "Likes", with: data.likesCount)
        questionsStatLabel.attributedText = getAttributedText(for: "Questions", with: data.questionsCount)
        answersStatLabel.attributedText = getAttributedText(for: "Answers", with: data.answersCount)
        somethingStatLabel.attributedText = getAttributedText(for: "Something", with: 0)
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
    
    @objc func handleEditProfile(){
        controller?.handleEditProfile()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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


class ProfileCell: UITableViewCell{
    let label = UILabel()
    let iconView = UIImageView()
    lazy var stackView = UIStackView(arrangedSubviews: [iconView, label])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        setupColors()
    }
    
    func setupUI(){
        label.font = .systemFont(ofSize: 14, weight: .medium)
        iconView.contentMode = .scaleAspectFit
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
    }
    
    func setupConstraints(){
        addSubview(stackView)
        iconView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        stackView.fillSuperView(padding: 7)
    }
    func setupColors(){
        label.textColor = selectedTheme.primaryTextColor
    }
    
    static var imageSize = CGSize(width: 24, height: 24)
    func setupData(_ text: String, _ imageName: String){
        let image = UIImage(named: imageName)?.resizeImage(size: ProfileCell.imageSize).withRenderingMode(.alwaysTemplate)
        iconView.image = image
        iconView.tintColor = selectedTheme.secondaryPlaceholderColor
        label.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
