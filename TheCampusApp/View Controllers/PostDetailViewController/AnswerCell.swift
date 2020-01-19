//
//  AnswerCell.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 11/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

// TODO: Determine whether this answer is liked by user or not

import UIKit

class AnswerCell: UITableViewCell{
    let answerLabel = UILabel()
    let profileDetailPic = DetailPictureView()
    let upvoteButton = VerticalButton()
    let downvoteButton = VerticalButton()
    var controlStack: UIStackView!
    
    var answer: Answers?{
        didSet{
            profileDetailPic.name = answer?.userName
            profileDetailPic.date = answer?.dateAnswered?.userReadableDate()
        }
    }
    
    var apprType: AppreciationType = .none{
        willSet(newValue){
            switch(apprType){
                case .none: break
                case .like: upvoteButton.tintColor = selectedTheme.secondaryPlaceholderColor
                case .dislike: downvoteButton.tintColor = selectedTheme.secondaryPlaceholderColor
            }
            switch(newValue){
                case .none: break
                case .like: upvoteButton.tintColor = selectedAccentColor.primaryColor
                case .dislike: downvoteButton.tintColor = selectedAccentColor.primaryColor
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupColors()
        setupConstraints()
        
        var name = Notification.Name(changeThemeKey)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeColorTheme), name: name, object: nil)
        
        name = Notification.Name(changeAccentColorKey)
        NotificationCenter.default.addObserver(self, selector: #selector(updateAccentColor), name: name, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didChangeColorTheme(){
        setupColors()
    }
    
    func setupColors(){
        profileDetailPic.dateLabel.textColor = selectedTheme.primaryTextColor
        profileDetailPic.detailsLabel.textColor = selectedTheme.primaryTextColor
        upvoteButton.tintColor = selectedTheme.secondaryPlaceholderColor
        downvoteButton.tintColor = selectedTheme.secondaryPlaceholderColor
    }
    
    func setupUI(){
        let upvoteImage = UIImage(named: "Like")?.withRenderingMode(.alwaysTemplate)
        upvoteButton.setImage(upvoteImage, for: .normal)
        upvoteButton.setTitle("12.4K", for: .normal)
        upvoteButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        upvoteButton.addTarget(self, action: #selector(handleUpvote), for: .touchUpInside)
        upvoteButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        let downvoteImage = UIImage(named: "Dislike")?.withRenderingMode(.alwaysTemplate)
        downvoteButton.setImage(downvoteImage, for: .normal)
        downvoteButton.setTitle("203", for: .normal)
        downvoteButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        downvoteButton.addTarget(self, action: #selector(handleDownvote), for: .touchUpInside)
        downvoteButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        let stack = UIStackView(arrangedSubviews: [upvoteButton, downvoteButton])
        stack.axis = .horizontal
        stack.alignment = .trailing
        stack.spacing = 5
        
        // Control Stack
        controlStack = UIStackView(arrangedSubviews: [profileDetailPic, stack])
        controlStack.axis = .horizontal
        controlStack.distribution = .equalSpacing
        
        answerLabel.font = .systemFont(ofSize: 16)
        answerLabel.numberOfLines = 0
    }
    
    func setupConstraints(){
        addSubview(answerLabel)
        addSubview(controlStack)
        
        answerLabel.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 10, paddingRight: 10)
        controlStack.anchor(top: answerLabel.bottomAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 10, paddingRight: 10, height: 50)
    }
    
    @objc func handleUpvote(){
        apprType = ((apprType == .like) ? .none: .like)
    }
    
    @objc func handleDownvote(){
        apprType = ((apprType == .dislike) ? .none: .dislike)
    }
    
    @objc func updateAccentColor() {
        switch(apprType){
            case .none: break
            case .like: upvoteButton.tintColor = selectedAccentColor.primaryColor
            case .dislike: downvoteButton.tintColor = selectedAccentColor.primaryColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
