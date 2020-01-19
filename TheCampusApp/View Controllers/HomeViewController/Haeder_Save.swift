////
////  PostDetailHeaderView.swift
////  TheCampusApp
////
////  Created by Yogesh Kumar on 13/01/20.
////  Copyright © 2020 Harsh Motwani. All rights reserved.
////
//
//import UIKit
//
//class PostDetailQuestionView: UITableViewHeaderFooterView{
//    let questionLabel = UILabel()
//    let descriptionLabel = UILabel()
//    let askerPictureView = DetailPictureView()
//    let upvoteButton = VerticalButton()
//    let downvoteButton = VerticalButton()
//    let expandButton = UIButton()
//    let seperator = UIView()
//    var controlStack: UIStackView!
//    
//    var isExpanded = false
//    var descriptionViewBottomConstraint: NSLayoutConstraint!
//    var currentURL: String?
//    
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        setupUI()
//        setupConstraints()
//        setupColors()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    var data: CompletePost?{
//        didSet{
//            questionLabel.text = data!.question
//            descriptionLabel.attributedText = data!.description
//            askerPictureView.name = data!.askerName
//            askerPictureView.date = data!.dateAsked?.userReadableDate()
//            loadDescription(forceLoad: false)
//            // loadAnswers(forceLoad: false)
//        }
//    }
//    
//    var controller: PostDetailViewController?
//
//    var apprType: AppreciationType = .none{
//        willSet(newValue){
//            switch(apprType){
//                case .none: break
//                case .like: upvoteButton.tintColor = selectedTheme.secondaryPlaceholderColor
//                case .dislike: downvoteButton.tintColor = selectedTheme.secondaryPlaceholderColor
//            }
//            switch(newValue){
//                case .none: break
//                case .like: upvoteButton.tintColor = selectedAccentColor.primaryColor
//                case .dislike: downvoteButton.tintColor = selectedAccentColor.primaryColor
//            }
//        }
//    }
//    
//    func setupColors(){
//        backgroundView?.backgroundColor = selectedTheme.primaryColor
//        questionLabel.textColor = selectedTheme.primaryTextColor
//        descriptionLabel.textColor = selectedTheme.primaryTextColor
//        askerPictureView.dateLabel.textColor = selectedTheme.primaryTextColor
//        askerPictureView.detailsLabel.textColor = selectedTheme.primaryTextColor
//        upvoteButton.setTitleColor(selectedTheme.secondaryPlaceholderColor, for: .normal)
//        downvoteButton.setTitleColor(selectedTheme.secondaryPlaceholderColor, for: .normal)
//        upvoteButton.tintColor = selectedTheme.secondaryPlaceholderColor
//        downvoteButton.tintColor = selectedTheme.secondaryPlaceholderColor
//        seperator.backgroundColor = selectedTheme.secondaryTextColor.withAlphaComponent(0.7)
//        expandButton.tintColor = selectedTheme.secondaryPlaceholderColor
//    }
//    
//    func setupConstraints(){
//        addSubview(backgroundView!)
//        addSubview(questionLabel)
//        addSubview(seperator)
//        addSubview(controlStack)
//        addSubview(descriptionLabel)
//        
//        backgroundView?.fillSuperView()
//    
//        questionLabel.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, paddingLeft: 10, paddingRight: 10)
//        
//        controlStack.anchor(top: questionLabel.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 15, paddingLeft: 10, paddingRight: 15)
//        expandButton.anchor(bottom: controlStack.bottomAnchor, paddingBottom: 25)
//        
//        // Description Label
//        descriptionLabel.anchor(top: controlStack.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
//
//        descriptionViewBottomConstraint = descriptionLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor)
//        descriptionViewBottomConstraint.isActive = true
//        
//        // Seperator
//        seperator.anchor(top: descriptionLabel.bottomAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 10, height: 2)
//    }
//    
//    func setupUI(){
//        // BackgroundView
//        backgroundView = UIView()
//        
//        // Upvote Button
//        let upvoteImage = UIImage(named: "Like")?.withRenderingMode(.alwaysTemplate)
//        upvoteButton.setImage(upvoteImage, for: .normal)
//        upvoteButton.setTitle("12.4K", for: .normal)
//        upvoteButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
//        upvoteButton.addTarget(self, action: #selector(handleUpvote), for: .touchUpInside)
//        upvoteButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        
//        // Downvote Button
//        let downvoteImage = UIImage(named: "Dislike")?.withRenderingMode(.alwaysTemplate)
//        downvoteButton.setImage(downvoteImage, for: .normal)
//        downvoteButton.setTitle("203", for: .normal)
//        downvoteButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
//        downvoteButton.addTarget(self, action: #selector(handleDownvote), for: .touchUpInside)
//        downvoteButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        
//        // Expnad Button
//        let expandImage = UIImage(named: "Expand")?.resizeImage(size: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
//        expandButton.setImage(expandImage, for: .normal)
//        expandButton.addTarget(self, action: #selector(handleDescription), for: .touchUpInside)
//        expandButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
//       
//        // Stack
//        let innerstack = UIStackView(arrangedSubviews: [upvoteButton, downvoteButton])
//        innerstack.axis = .horizontal
//        innerstack.alignment = .trailing
//        innerstack.spacing = 5
//        
//        // Picture View
//        askerPictureView.isAnswer = false
//        
//        // Control Stack
//        controlStack = UIStackView(arrangedSubviews: [askerPictureView, innerstack, expandButton])
//        controlStack.axis = .horizontal
//        controlStack.distribution = .equalSpacing
//        
//        // Question Label
//        questionLabel.numberOfLines = 0
//        questionLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
//        
//        // Question Description
//        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
//        descriptionLabel.numberOfLines = 0
//    }
//    
//    func loadDescription(forceLoad: Bool = false){
//        if(data?.description == nil || forceLoad){
//            if let descriptionURL = data!.descriptionURLString, descriptionURL != currentURL{
//                self.currentURL = descriptionURL
//                APIService.loadDescription(from: descriptionURL){ (url, data) in
//                    print(url, descriptionURL)
//                    self.descriptionLabel.attributedText = data.toAttributedString()
//                    self.data?.description = self.descriptionLabel.attributedText
//                    self.currentURL = nil
//                }
//            }
//        }
//        else{
//            self.descriptionLabel.attributedText = data?.description
//        }
//    }
//    
//    @objc func handleDescription(){
//        if(isExpanded){
//            self.descriptionViewBottomConstraint.isActive = true
//
//            UIView.animate(withDuration: 0.5, animations: {
//                self.controller?.tableView.beginUpdates()
//                self.descriptionLabel.alpha = 0
//                self.layoutIfNeeded()
//                self.expandButton.transform = .identity
//                self.controller?.tableView.endUpdates()
//            })
//        }
//        else{
//            self.descriptionViewBottomConstraint.isActive = false
//            UIView.animate(withDuration: 0.5, animations: {
//                self.controller?.tableView.beginUpdates()
//                self.descriptionLabel.alpha = 1
//                self.layoutIfNeeded()
//                self.expandButton.transform = self.expandButton.transform.rotated(by: 0.99 * CGFloat.pi)
//                self.controller?.tableView.endUpdates()
//            })
//        }
//        isExpanded = !isExpanded
//    }
//    
//    @objc func handleUpvote(){
//        apprType = ((apprType == .like) ? .none: .like)
//    }
//    
//    @objc func handleDownvote(){
//        apprType = ((apprType == .dislike) ? .none: .dislike)
//    }
//    
//    func updateAccentColor() {
//        switch(apprType){
//            case .none: break
//            case .like: upvoteButton.tintColor = selectedAccentColor.primaryColor
//            case .dislike: downvoteButton.tintColor = selectedAccentColor.primaryColor
//        }
//    }
//}
//
//
