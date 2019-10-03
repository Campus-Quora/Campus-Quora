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
    // MARK:- Data Members
    var isKeyboardVisible: Bool = true
    var shouldMoveDown: Bool = true
    var keyBoardHeight: CGFloat?{
        didSet{
//            guard let height = keyBoardHeight else {return}
//            extraOptionsView.translatesAutoresizingMaskIntoConstraints = false
//            extraOptionsView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
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
            navBar.prefersLargeTitles = true
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
        return view
    }()
    
    let tipsView: UILabel = {
        let label = UILabel()
        label.attributedText = tipAttributedString()
        label.numberOfLines = 0
        return label
    }()
    
    let questionHeading: TextEditor = {
        let textView = TextEditor(padding: 10, customHTML: "QuestionHeader")
        textView.becomeFirstResponder()
        textView.placeholderLabel.text = "Start your question with \"What\", \"How\", \"Why\", etc"
        textView.placeholderLabel.font = .systemFont(ofSize: 20, weight: .bold)
        textView.tag = 0
        return textView
    }()
    
    let margin: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let questionDescription: TextEditor = {
        let textView = TextEditor(padding: 10, customHTML: "QuestionDescription")
        textView.placeholderLabel.text = "Optional: Include a decription"
        textView.placeholderLabel.font = .systemFont(ofSize: 18, weight: .bold)
        textView.tag = 1
        return textView
    }()
    
    lazy var toolbar: CustomToolBar = {
        let bar = CustomToolBar(height: 60, controller: self)
        bar.toolSpacing = 35
        bar.edgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        bar.leftItems = [addImageButton, showKeyboardButton, extraOptionsButton]
        bar.rightItems = [askButton]
        bar.layout()
        return bar
    }()
    
    let askButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ask", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5;
        button.isEnabled = false
        button.backgroundColor = blueColorFaint
        button.addTarget(self, action: #selector(handleAsk), for: .touchUpInside)
        return button
    }()
    
    let addImageButton: UIButton = {
        let button = ToolBarButton(imageName: "AddImage")
        button.tag = 0
        button.addTarget(self, action: #selector(handleButtonColor), for: .touchUpInside)
        return button
    }()
    
    let showKeyboardButton: UIButton = {
        let button = ToolBarButton(imageName: "Keyboard")
        button.tag = 1
        button.addTarget(self, action: #selector(handleButtonColor), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleShowKeyboard), for: .touchUpInside)
        button.tintColor = selectedColor
        return button
    }()
    
    let extraOptionsButton: ToolBarButton = {
        let button = ToolBarButton(imageName: "Paragraph")
        button.tag = 2
         button.addTarget(self, action: #selector(handleExtraOptions), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleButtonColor), for: .touchUpInside)
        return button
    }()
    
    lazy var extraOptionsView: ExtraTextOptionsView = {
        let view = ExtraTextOptionsView(padding: 20)
        view.alpha = 0
        view.clipsToBounds = true
        return view
    }()
    
//    override var inputAccessoryView:UIView{
//        get{ return self.toolbar }
//    }
//
    override var canBecomeFirstResponder: Bool{
        get{ return true }
    }
//
//    override var inputView: UIView?{
//        get{ return self.extraOptionsView }
//    }
    func setupUI(){
        view.backgroundColor = primaryColor
    
        // Add Subviews
        view.addSubview(scrollView)
        scrollView.bounces = false
        scrollView.addSubview(tipsView)
        scrollView.addSubview(questionHeading)
        scrollView.addSubview(questionDescription)
        scrollView.addSubview(extraOptionsView)
        scrollView.addSubview(margin)
//        view.addSubview(tipsView)
//        view.addSubview(questionHeading)
//        view.addSubview(questionDescription)
//        view.addSubview(extraOptionsView)
//        view.addSubview(margin)
        
        // Setup Delegates
        questionHeading.delegate = self
        questionDescription.delegate = self
        
        addConstraints()
    }
    
    // Add Constraints
    fileprivate func addConstraints() {
//        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.anchor(top: view.topAnchor, left: view.leadingAnchor)
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
        
        tipsView.anchor(top: scrollView.topAnchor, left: scrollView.leadingAnchor, right: view.trailingAnchor, paddingLeft: 10, paddingRight: 10)
        questionHeading.anchor(top: tipsView.bottomAnchor, left: scrollView.leadingAnchor, right: view.trailingAnchor)
        margin.anchor(top: questionHeading.bottomAnchor, left: scrollView.leadingAnchor, right: view.trailingAnchor, height: 1)
        questionDescription.anchor(top: margin.bottomAnchor, bottom: scrollView.bottomAnchor, left: scrollView.leadingAnchor, right: view.trailingAnchor)
        askButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        extraOptionsView.anchor(top: toolbar.bottomAnchor, left: scrollView.leadingAnchor, right: scrollView.trailingAnchor)
//
//        tipsView.anchor(top: view.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingLeft: 10, paddingRight: 10)
//        questionHeading.anchor(top: tipsView.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor)
//        margin.anchor(top: questionHeading.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, height: 1)
//        questionDescription.anchor(top: margin.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor)
//        askButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        extraOptionsView.anchor(top: toolbar.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor)
    }
    
    // MARK:- Event Handler
    
    @objc func handleAsk(){
        print("Asking")
    }
    
    @objc func handleButtonColor(_ sender: UIButton){
        sender.tintColor = selectedColor
        for button in toolbar.leftItems{
            if button.tag != sender.tag{
                button.tintColor = unselectedColor
            }
        }
    }
    
    @objc func handleShowKeyboard(){
        if(!isKeyboardVisible){
            if(!questionHeading.placeholderLabel.isHidden){
                questionHeading.becomeFirstResponder()
            }
            else{
                questionDescription.becomeFirstResponder()
            }
            extraOptionsView.alpha = 0
        }
    }
    
    @objc func handleExtraOptions(){
        if(isKeyboardVisible){
            shouldMoveDown = false
            extraOptionsView.alpha = 1
            UIView.setAnimationsEnabled(false)
            view.endEditing(true)
        }
        else{
            
        }
    }
}

extension PostViewController: CustomToolBarDelegate {
    // This is triggered when keyboards shows up
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect{
            isKeyboardVisible = notification.name == UIResponder.keyboardWillShowNotification
            
            adjustInsetForKeyboardShow(isKeyboardVisible, height: keyboardFrame.height)
            
//            if(isKeyboardVisible){
//                let tabBarHeight = tabBarController!.tabBar.frame.size.height
//                if keyBoardHeight == nil{
//                    keyBoardHeight = keyboardFrame.height - tabBarHeight
//                }
//                toolbar.bottomConstraint.constant = -(keyboardFrame.height - tabBarHeight)
//                UIView.setAnimationsEnabled(true)
//            }
//            else if(shouldMoveDown){
//                toolbar.bottomConstraint.constant = 0
//            }
//            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
//                self.view.layoutIfNeeded()
//            }, completion: nil)
        }
    }
    
    func adjustInsetForKeyboardShow(_ show: Bool, height: CGFloat) {
        let tabbarHeight = tabBarController?.tabBar.frame.size.height ?? 0
        let toolbarHeight = navigationController?.toolbar.frame.size.height ?? 0
        let bottomInset = height - tabbarHeight - toolbarHeight
        
        let adjustmentHeight = (bottomInset + 20) * (show ? 1 : -1)
        scrollView.contentInset.bottom += adjustmentHeight
        scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
        print(adjustmentHeight)
        if(show){
            var aRect = self.view.frame;
            print(aRect)
            aRect.size.height -= adjustmentHeight;

            let activeField: TextEditor? = [questionHeading, questionDescription].first { $0.isFirstResponder }
            if let activeField = activeField {
                if aRect.contains(activeField.frame.origin) {
                    let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y - adjustmentHeight)
                    print(scrollPoint)
                    scrollView.setContentOffset(scrollPoint, animated: true)
                }
            }
        }
    }
}

// MARK:- Extension #1
extension PostViewController: TextEditorDelegate{
    
    func heightDidChange(_ height: CGFloat, for editor: TextEditor) {
    }
    
    func textDidChange(_ text: inout String, for editor: TextEditor) {
        checkValidInput(&text)
    }
    
    // This is triggered when Keyboards shows
    
    // This functions check if input text field in valid
    func checkValidInput(_ text: inout String){
        let isQuestionNonEmpty = text.count > 0
        
        if isQuestionNonEmpty{
            askButton.isEnabled = true
            askButton.backgroundColor = blueColorDark
        }
        else{
            askButton.isEnabled = false
            askButton.backgroundColor = blueColorFaint
        }
    }
}

extension PostViewController: UIScrollViewDelegate{
    
}
