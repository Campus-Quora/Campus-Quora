//
//  PostViewController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 27/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

let selectedColor = blueColorDark
let unselectedColor: UIColor = .black

class PostViewController: UIViewController{
    // MARK:- Overriden Members
    override var inputAccessoryView:UIView{
        get{ return self.toolbar }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    // MARK:- Main Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        
        // Add Notification Observers for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupNavigationBar(){
        navigationItem.title = "Ask A Question"
        guard let navBar = navigationController?.navigationBar else {return}
        if #available(iOS 11.0, *) {
            // BUG:- Title doesn't return to being large when scrolled upto top
            // Setting large title causes some issues in handling scrollview offset with keyboard events
            // navBar.prefersLargeTitles = true
        }
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = false
        navBar.tintColor = primaryColor
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK:- UI Elements
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.bounces = false
        return view
    }()
    
    let tipsView: UILabel = {
        let label = UILabel()
        label.attributedText = tipAttributedString()
        label.numberOfLines = 0
        return label
    }()
    
    let questionHeadingPlaceholderText: NSAttributedString = {
        let placeholder = "Start your question with \"What\", \"How\", \"Why\", etc"
        return NSAttributedString(string: placeholder, attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .bold), .foregroundColor: UIColor.lightGray])
    }()
    
    let questionDescriptionPlaceholderText: NSAttributedString = {
        let placeholder = "Optional : Provide some extra details, add images or links"
        return NSAttributedString(string: placeholder, attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .medium), .foregroundColor: UIColor.lightGray])
    }()
    
    lazy var questionHeading: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        scrollView.addSubview(textView)
        textView.attributedPlaceholder = questionHeadingPlaceholderText
        textView.constrainRight(to: self.view)
        textView.textContainerInset.bottom += 24
        textView.font = .systemFont(ofSize: 20, weight: .bold)
        textView.isScrollEnabled = false
        return textView
    }()
    
    lazy var questionDescription: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        scrollView.addSubview(textView)
        textView.attributedPlaceholder = questionDescriptionPlaceholderText
        textView.constrainRight(to: self.view)
        textView.textContainerInset.bottom += 24
        textView.font = .systemFont(ofSize: 16, weight: .bold)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let margin: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    // This fixes an issue of scrollView offset with keyboard
    let bottomMargin: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK:- Tool Bar
    lazy var toolbar: CustomToolBar = {
        let bar = CustomToolBar()
        bar.backgroundColor = .white
        bar.autoresizingMask = .flexibleHeight
        bar.toolSpacing = 35
        bar.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        bar.leftItems = [addImageButton, addLinkButton, textOptionsButton]
        bar.rightItems = [askButton]
        bar.layout()
        return bar
    }()
    
    // Right Toolbar Buttons
    let askButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5;
        button.backgroundColor = blueColorDark
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return button
    }()
    
    // Left Toolbar Buttons
    let addImageButton: UIButton = {
        let button = ToolBarButton(imageName: "AddImage")
        button.tag = 0
        button.addTarget(self, action: #selector(handleButtonColor), for: .touchUpInside)
        return button
    }()
    
    let addLinkButton: UIButton = {
        let button = ToolBarButton(imageName: "Link")
        button.tag = 1
        button.addTarget(self, action: #selector(handleButtonColor), for: .touchUpInside)
        return button
    }()
    
    let textOptionsButton: ToolBarButton = {
        let button = ToolBarButton(imageName: "Paragraph")
        button.tag = 2
         button.addTarget(self, action: #selector(handleTextOptions), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleButtonColor), for: .touchUpInside)
        return button
    }()
    
    func setupUI(){
        view.backgroundColor = primaryColor
    
        // Add Subviews
        view.addSubview(scrollView)
        scrollView.addSubview(tipsView)
        scrollView.addSubview(margin)
        scrollView.addSubview(bottomMargin)
        
        // Setup Delegates
        questionHeading.delegate = self
        questionDescription.delegate = self
        
        addConstraints()
    }
    
    // Add Constraints
    fileprivate func addConstraints() {
        // Scroll View
        scrollView.anchor(top: view.topAnchor, left: view.leadingAnchor)
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
        
        // Tips View
        tipsView.anchor(top: scrollView.topAnchor, left: scrollView.leadingAnchor, right: view.trailingAnchor, paddingLeft: 10, paddingRight: 10)
        
        // Question Heading
        questionHeading.anchor(top: tipsView.bottomAnchor, left: scrollView.leadingAnchor, right: view.trailingAnchor)
        questionHeading.sizeToFit()
        questionHeading.setContentOffset(CGPoint.zero, animated: false)
        
        // Question Description
        questionDescription.anchor(top: margin.bottomAnchor, left: scrollView.leadingAnchor, right: view.trailingAnchor)
        questionDescription.sizeToFit()
        questionDescription.setContentOffset(CGPoint.zero, animated: false)
        
        // Margins
        margin.anchor(top: questionHeading.bottomAnchor, left: scrollView.leadingAnchor, right: view.trailingAnchor, height: 1)
        bottomMargin.anchor(top: questionDescription.bottomAnchor, bottom: scrollView.bottomAnchor, left: scrollView.leadingAnchor, right: view.trailingAnchor, height: 1)
    }
    
}
