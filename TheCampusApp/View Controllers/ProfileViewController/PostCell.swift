//
//  CollectionViewCell.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 28/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

struct PostData{
    var question: String?
    var answer: String?
    var personWhoAnswered: String?
    var date: String?
}

let seperatorColor: UIColor = .gray
let seperatorSize: CGFloat =  2

class PostCell: UICollectionViewCell{
    var postData: PostData?{
        didSet{
            questionLabel.text = postData?.question
            answerLabel.text = postData?.answer
            personWhoAnsweredPic.personWhoAnswered = postData?.personWhoAnswered
            personWhoAnsweredPic.date = postData?.date 
        }
    }

    
    // UI Elements
    let questionLabel: UILabel = {
        let label = UILabel()
        label.font = questionFont
        label.numberOfLines = numberOfLinesInQuestion
        return label
    }()
    
    let answerLabel: UILabel = {
        let label = UILabel()
        label.font = answerFont
        label.numberOfLines = numberOfLinesInAnswer
        return label
    }()
    
    let personWhoAnsweredPic: PersonWhoAnsweredPic = {
        let person = PersonWhoAnsweredPic()
        return person
    }()
    
    let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = seperatorColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .yellow
        setupUI()
    }
    
    func setupUI(){
        addSubview(seperator)
        seperator.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, height: seperatorSize)
        
        addSubview(questionLabel)
        questionLabel.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 10)
//        questionLabel.backgroundColor = .red
        
        addSubview(personWhoAnsweredPic)
        personWhoAnsweredPic.anchor(top: questionLabel.bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 5, height: 50)
        
        addSubview(answerLabel)
        answerLabel.anchor(top: personWhoAnsweredPic.bottomAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 10, paddingBottom: 10)
//        answerLabel.backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PersonWhoAnsweredPic: UIView{
    var personWhoAnswered: String? {
        didSet {
            detailsLabel.text = personWhoAnswered
        }
    }
    
    var date: String? {
        didSet {
            dateLabel.text = "Answered on \(date!)"
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
        photo.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.85).isActive = true
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
