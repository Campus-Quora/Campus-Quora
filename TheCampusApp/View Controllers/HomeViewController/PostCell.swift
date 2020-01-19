//
//  CollectionViewCell.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 28/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

fileprivate let seperatorColor: UIColor = selectedTheme.secondaryTextColor
fileprivate let seperatorSize: CGFloat =  2

class UnansweredPostCell: UITableViewCell{
    var postData: CompletePost?{
        didSet{
            questionLabel.text = postData?.question
            detailPictureView.isAnswer = false
            detailPictureView.name = postData?.askerName
            detailPictureView.date = postData?.dateAsked?.userReadableDate()
        }
    }
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.font = questionFont
        label.numberOfLines = numberOfLinesInQuestion
        return label
    }()
    let detailPictureView = DetailPictureView()
    let seperator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupColors()
        setupUI()
        
        let name = Notification.Name(changeThemeKey)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeColorTheme), name: name, object: nil)
    }
    
    @objc func didChangeColorTheme(){
        setupColors()
    }
    
    func setupColors(){
        questionLabel.textColor = selectedTheme.primaryTextColor
        seperator.backgroundColor = selectedTheme.secondaryTextColor
        detailPictureView.dateLabel.textColor = selectedTheme.primaryTextColor
        detailPictureView.detailsLabel.textColor = selectedTheme.primaryTextColor
    }
    
    func setupUI(){
        addSubview(seperator)
        seperator.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, paddingLeft: 10, paddingRight: 10, height: seperatorSize)
        
        addSubview(questionLabel)
        questionLabel.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        addSubview(detailPictureView)
        detailPictureView.anchor(top: questionLabel.bottomAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 5, paddingBottom: 10, paddingLeft: 10, paddingRight: 10, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

class AnsweredPostCell: UnansweredPostCell{
    override var postData: CompletePost?{
        didSet{
            questionLabel.text = postData?.question
            if let answer = postData?.topAnswer{
                answerLabel.text = answer
                detailPictureView.name = postData?.topAnswerUserName
                detailPictureView.date = postData?.dateAnswered?.userReadableDate()
            }
        }
    }
    
    let answerLabel: UILabel = {
        let label = UILabel()
        label.font = answerFont
        label.numberOfLines = numberOfLinesInAnswer
        return label
    }()
    
    override func setupColors(){
        super.setupColors()
        answerLabel.textColor = selectedTheme.primaryTextColor
    }
    
    override func setupUI(){
        addSubview(seperator)
        seperator.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, paddingLeft: 10, paddingRight: 10, height: seperatorSize)
        
        addSubview(questionLabel)
        questionLabel.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        addSubview(detailPictureView)
        detailPictureView.anchor(top: questionLabel.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 10, height: 50)
        
        addSubview(answerLabel)
        answerLabel.anchor(top: detailPictureView.bottomAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

class DetailPictureView: UIView{
    var name: String? {
        didSet {
            detailsLabel.text = name
        }
    }
    
    var isAnswer: Bool = true
    var date: String? {
        didSet {
            guard let date = date else{return}
            if(isAnswer){
                dateLabel.text = "Answered on \(date)"
            }
            else{
                dateLabel.text = "Asked on \(date)"
            }
        }
    }
    // UI Elements
    let photo : RoundImageView = {
        let imageView = RoundImageView()
        imageView.image = UIImage(named: "Avatar")
        return imageView
    }()
    
    let detailsLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .ultraLight)
        return label
    }()
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    func setupUI(){
        // Photo
        addSubview(photo)
        photo.centerY(centerYAnchor)
        photo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        photo.heightAnchor.constraint(equalToConstant: 38).isActive = true
        photo.widthAnchor.constraint(equalTo: photo.heightAnchor, multiplier: 1).isActive = true
        
        // Details
        let stack = UIStackView(arrangedSubviews: [detailsLabel, dateLabel])
        addSubview(stack)
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.anchor(top: topAnchor, bottom: bottomAnchor, left: photo.trailingAnchor, right: trailingAnchor, paddingLeft: 10, paddingRight: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
