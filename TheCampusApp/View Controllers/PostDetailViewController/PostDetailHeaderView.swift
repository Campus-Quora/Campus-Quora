//
//  PostDetailHeaderView.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 13/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    var inset: UIEdgeInsets?

    override func drawText(in rect: CGRect) {
        if let inset = self.inset{
            super.drawText(in: rect.inset(by: inset))
        }
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = size.width + (inset?.left ?? 0) + (inset?.right ?? 0)
        let height = size.height + (inset?.top ?? 0) + (inset?.bottom ?? 0)
        return CGSize(width: width, height: height)
    }
}

class PostDetailQuestionView: UITableViewHeaderFooterView{
    let questionLabel = UILabel()
    let descriptionLabel = PaddingLabel()
    let askerPictureView = DetailPictureView()
    let upvoteButton = VerticalButton()
    let downvoteButton = VerticalButton()
    let bookmarkButton = VerticalButton()
    let shareButton = VerticalButton()
    let expandButton = UIButton()
    let seperator = UIView()
    let tagView = TagStripView()
    
    var askerDetailsStack: UIStackView!
    var optionsStack: UIStackView!
    var controlStack: UIStackView!
    var expandStack: UIStackView!
    
    var isExpanded = false
    var expandStackBottomConstraint: NSLayoutConstraint!
    var currentURL: String?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        setupColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var data: CompletePost?{
        didSet{
            guard let data = data else{return}
            questionLabel.text = data.question
            descriptionLabel.attributedText = data.description
            askerPictureView.name = data.askerName
            askerPictureView.date = data.dateAsked?.userReadableDate()
            loadDescription(forceLoad: false)
            loadApprType(forceLoad: false)
            apprType = data.apprType ?? .none
            bookmark = data.bookmark ?? false
            tagView.data = data.tags ?? []
            tagView.collectionView.reloadData()
        }
    }
    
    weak var controller: PostDetailViewController?

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
    
    var bookmark: Bool = false{
        didSet{
            if(bookmark){
                bookmarkButton.tintColor = selectedAccentColor.primaryColor
            }
            else{
                bookmarkButton.tintColor = selectedTheme.secondaryPlaceholderColor
            }
        }
    }
    
    func updateApprType(){
        if((apprType != data?.apprType) || (bookmark != data?.bookmark)){
            APIService.updatePostApprType(for: data?.postID, apprType: apprType, bookmark: bookmark)
            data?.apprType = apprType
        }
        if(bookmark != data?.bookmark){
            APIService.updateBookmark(for: data?.postID, bookmark: bookmark){_ in }
            data?.bookmark = bookmark
        }
    }
    
    func setupColors(){
        backgroundView?.backgroundColor = selectedTheme.primaryColor
        questionLabel.textColor = selectedTheme.primaryTextColor
        descriptionLabel.textColor = selectedTheme.primaryTextColor
        askerPictureView.dateLabel.textColor = selectedTheme.primaryTextColor
        askerPictureView.detailsLabel.textColor = selectedTheme.primaryTextColor
        optionsStack.arrangedSubviews.forEach { (stackButton) in
            (stackButton as! UIButton).setTitleColor(selectedTheme.secondaryPlaceholderColor, for: .normal)
            (stackButton as! UIButton).tintColor = selectedTheme.secondaryPlaceholderColor
        }
        seperator.backgroundColor = selectedTheme.secondaryTextColor.withAlphaComponent(0.7)
        expandButton.tintColor = selectedTheme.secondaryPlaceholderColor
    }
    
    func setupConstraints(){
        addSubview(backgroundView!)
        addSubview(questionLabel)
        addSubview(seperator)
        addSubview(controlStack)
        addSubview(expandStack)
        
        backgroundView?.fillSuperView()
    
        questionLabel.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, paddingLeft: 10, paddingRight: 10)
        
        controlStack.anchor(top: questionLabel.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 15, paddingLeft: 10, paddingRight: 15)
        
        // Description Label
        expandStack.anchor(top: controlStack.bottomAnchor, left: leadingAnchor, right: trailingAnchor)
        let constraints = [
            descriptionLabel.leadingAnchor.constraint(equalTo: expandStack.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: expandStack.trailingAnchor, constant: -10)
        ]
        
        constraints.forEach { (constraint) in
            constraint.priority = .defaultHigh
            constraint.isActive = true
        }

        expandStackBottomConstraint = expandStack.bottomAnchor.constraint(equalTo: expandStack.topAnchor)
        expandStackBottomConstraint.isActive = true
        
        // Seperator
        seperator.anchor(top: descriptionLabel.bottomAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 10, height: 2)
    }
    
    func setupUI(){
        // BackgroundView
        backgroundView = UIView()
        
        let size = CGSize(width: 24, height: 24)
        // Upvote Button
        let upvoteImage = UIImage(named: "Like")?.resizeImage(size: size).withRenderingMode(.alwaysTemplate)
        upvoteButton.setImage(upvoteImage, for: .normal)
        upvoteButton.setTitle("Like", for: .normal)
        upvoteButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        upvoteButton.addTarget(self, action: #selector(handleUpvote), for: .touchUpInside)
        upvoteButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        // Downvote Button
        let downvoteImage = UIImage(named: "Dislike")?.resizeImage(size: size).withRenderingMode(.alwaysTemplate)
        downvoteButton.setImage(downvoteImage, for: .normal)
        downvoteButton.setTitle("Dislike", for: .normal)
        downvoteButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        downvoteButton.addTarget(self, action: #selector(handleDownvote), for: .touchUpInside)
        downvoteButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        // Bookmark Button
        let bookmarkImage = UIImage(named: "Bookmark")?.resizeImage(size: size).withRenderingMode(.alwaysTemplate)
        bookmarkButton.setImage(bookmarkImage, for: .normal)
        bookmarkButton.setTitle("Save", for: .normal)
        bookmarkButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        bookmarkButton.addTarget(self, action: #selector(handleBookmark), for: .touchUpInside)
        bookmarkButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        let shareImage = UIImage(named: "Share")?.resizeImage(size: size).withRenderingMode(.alwaysTemplate)
        shareButton.setImage(shareImage, for: .normal)
        shareButton.setTitle("Share", for: .normal)
        shareButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        shareButton.addTarget(self, action: #selector(handleBookmark), for: .touchUpInside)
        shareButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        // Expnad Button
        let expandImage = UIImage(named: "Expand")?.resizeImage(size: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
        expandButton.setImage(expandImage, for: .normal)
        expandButton.addTarget(self, action: #selector(handleDescription), for: .touchUpInside)
        expandButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
       
        // Stack
        askerDetailsStack = UIStackView(arrangedSubviews: [askerPictureView, expandButton])
        askerDetailsStack.axis = .horizontal
        askerDetailsStack.distribution = .fillProportionally
        
        optionsStack = UIStackView(arrangedSubviews: [upvoteButton, downvoteButton, bookmarkButton, shareButton])
        optionsStack.axis = .horizontal
        optionsStack.distribution = .fillEqually
        
        // Picture View
        askerPictureView.isAnswer = false
        
        // Control Stack
        controlStack = UIStackView(arrangedSubviews: [askerDetailsStack, optionsStack])
        controlStack.axis = .vertical
        controlStack.spacing = 15
        
        // Question Label
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        // Question Description
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.inset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        // Expand Stack
        expandStack = UIStackView(arrangedSubviews: [tagView, descriptionLabel])
        expandStack.axis = .vertical
        expandStack.distribution = .fillProportionally
    }
    
    func loadDescription(forceLoad: Bool = false){
        if(data?.description == nil || forceLoad){
            if let descriptionURL = data!.descriptionURLString, descriptionURL != currentURL{
                self.currentURL = descriptionURL
                APIService.loadDescription(from: descriptionURL){ [weak self] (url, data) in
                    guard let self = self else {return}
                    print(url, descriptionURL)
                    self.descriptionLabel.attributedText = data.toAttributedString()
                    self.data?.description = self.descriptionLabel.attributedText
                    self.currentURL = nil
                }
            }
        }
        else{
            self.descriptionLabel.attributedText = data?.description
        }
    }
    
    func loadApprType(forceLoad: Bool = false){
        if((data?.apprType == nil) || (data?.bookmark == nil) || forceLoad){
            APIService.getApprType(for: data?.postID){
                [weak self] (apprType, bookmark) in
                guard let self = self else {return}
                self.apprType = apprType
                self.bookmark = bookmark
                self.data?.apprType = apprType
                self.data?.bookmark = bookmark
            }
        }
        else{
            self.apprType = (data?.apprType)!
            self.bookmark = (data?.bookmark)!
        }
    }
    
    @objc func handleDescription(){
        if(isExpanded){
            self.expandStackBottomConstraint.isActive = true

            UIView.animate(withDuration: 0.2) {
                self.descriptionLabel.alpha = 0
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.controller?.tableView.beginUpdates()
                self.layoutIfNeeded()
                self.expandButton.transform = .identity
                self.controller?.tableView.endUpdates()
            })
        }
        else{
            self.expandStackBottomConstraint.isActive = false
            UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveLinear, animations: {
                self.descriptionLabel.alpha = 1
            }, completion: nil)
            UIView.animate(withDuration: 0.5, animations: {
                self.controller?.tableView.beginUpdates()
                self.layoutIfNeeded()
                self.expandButton.transform = self.expandButton.transform.rotated(by: 0.99 * CGFloat.pi)
                self.controller?.tableView.endUpdates()
            })
        }
        isExpanded = !isExpanded
    }
    
    @objc func handleUpvote(){
        apprType = ((apprType == .like) ? .none: .like)
    }
    
    @objc func handleDownvote(){
        apprType = ((apprType == .dislike) ? .none: .dislike)
    }
    
    @objc func handleBookmark(){
        bookmark = !bookmark
    }
    
    func updateAccentColor() {
        switch(apprType){
            case .none: break
            case .like: upvoteButton.tintColor = selectedAccentColor.primaryColor
            case .dislike: downvoteButton.tintColor = selectedAccentColor.primaryColor
        }
        if(bookmark){
            bookmarkButton.tintColor = selectedAccentColor.primaryColor
        }
    }
}


