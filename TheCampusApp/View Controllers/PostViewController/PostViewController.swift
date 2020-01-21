//
//  PostViewController2.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 15/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit
import Photos
import Firebase
import IQKeyboardManagerSwift

class PostViewController: TextEditorViewController{
    // MARK:- UI Elements
    let scrollView = UIScrollView()
    let tipsView = UILabel()
    let cancelButton = UIButton()
    let askButton = UIButton()
    let questionTextView = PlaceholderTextView()
    let descriptionTextView = PlaceholderTextView()
    let margin = UIView()
    let questionToolbar = CustomToolBar()
    let doneButton2 = UIButton()
    var questionTextViewHeightContraint: NSLayoutConstraint?
    
    // MARK:- Main Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupText()
        self.edgesForExtendedLayout = UIRectEdge.top
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.1) {
            self.toolbar.alpha = 0
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(size)
        super.viewWillTransition(to: size, with: coordinator)
        updateQuestionTextViewHeight(size: size)
    }
    
    override func setupNavigationBar(){
        super.setupNavigationBar()
        navigationItem.title = "Ask A Question"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: askButton)
        guard let navBar = navigationController?.navigationBar else{return}
        if #available(iOS 11.0, *) {
            // BUG:- Title doesn't return to being large when scrolled upto top
            // Setting large title causes some issues in handling scrollview offset with keyboard events
             navBar.prefersLargeTitles = false
        }
    }
    
    // MARK:- SETUP
    override func setupUI(){
        super.setupUI()
        // Cancel Button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.tintColor = selectedTheme.primaryTextColor
        cancelButton.layer.cornerRadius = 10;
        cancelButton.backgroundColor = selectedTheme.secondaryPlaceholderColor
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        cancelButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        // Submit Button
        askButton.setTitle("Submit", for: .normal)
        askButton.tintColor = .white
        askButton.layer.cornerRadius = 10;
        askButton.backgroundColor = selectedAccentColor.secondaryColor
        askButton.addTarget(self, action: #selector(handleAsk), for: .touchUpInside)
        askButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        askButton.isUserInteractionEnabled = false
        
        // Question Toolbar
        doneButton2.setTitle("Done", for: .normal)
        doneButton2.tintColor = .white
        doneButton2.layer.cornerRadius = 5;
        doneButton2.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        doneButton2.widthAnchor.constraint(equalToConstant: 70).isActive = true
        doneButton2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        questionToolbar.autoresizingMask = .flexibleHeight
        questionToolbar.toolSpacing = 20
        questionToolbar.edgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 7)
        questionToolbar.rightItems = [doneButton2]
        questionToolbar.layout()
        
        // Question Text View
        questionTextView.textContainerInset.bottom += 24
        questionTextView.font = .systemFont(ofSize: 20, weight: .bold)
        questionTextView.isScrollEnabled = false
        questionTextView.showsVerticalScrollIndicator = false
        questionTextView.becomeFirstResponder()
        questionTextView.backgroundColor = .clear
        questionTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        questionTextView.setContentOffset(.zero, animated: false)
        questionTextView.isScrollEnabled = false
        questionTextView.inputAccessoryView = questionToolbar
        questionTextView.delegate = self

        // Description Text View
        descriptionTextView.textContainerInset.bottom += 24
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.inputAccessoryView = self.toolbar
        descriptionTextView.isScrollEnabled = true
        descriptionTextView.showsVerticalScrollIndicator = false
        descriptionTextView.setContentOffset(.zero, animated: false)
        descriptionTextView.delegate = self
        textOptionsView.dataSource = descriptionTextView
    }
    
    override func setupConstraints(){
        super.setupConstraints()
        view.addSubview(questionTextView)
        view.addSubview(descriptionTextView)
        view.addSubview(margin)
        
        questionTextView.setupPlaceholderConstraints(view)
        descriptionTextView.setupPlaceholderConstraints(view)
        
        // Question Text View
        if #available(iOS 11.0, *) {
            let safeLayout = view.safeAreaLayoutGuide
            questionTextView.anchor(top: safeLayout.topAnchor, left: safeLayout.leadingAnchor, right: safeLayout.trailingAnchor)
        }
        else{
            questionTextView.anchor(top: view.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor)
        }
        questionTextViewHeightContraint = questionTextView.heightAnchor.constraint(equalToConstant: 80)
        questionTextViewHeightContraint?.isActive = true
        
        if #available(iOS 11.0, *) {
            let safeLayout = view.safeAreaLayoutGuide
            descriptionTextView.anchor(top: margin.bottomAnchor, bottom: safeLayout.bottomAnchor, left: safeLayout.leadingAnchor, right: safeLayout.trailingAnchor)
        } else {
            descriptionTextView.anchor(top: margin.bottomAnchor, bottom: view.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor)
        }
        
        margin.anchor(top: questionTextView.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, height: 1)
    }
    
    // MARK:- THEMES AND COLORS
    override func setupThemeColors(){
        super.setupThemeColors()
        view.backgroundColor = selectedTheme.primaryColor
        questionTextView.keyboardAppearance = selectedTheme.keyboardStyle
        questionTextView.textColor = selectedTheme.primaryTextColor
        
        descriptionTextView.keyboardAppearance = selectedTheme.keyboardStyle
        descriptionTextView.textColor = selectedTheme.primaryTextColor
        margin.backgroundColor = selectedTheme.secondaryTextColor
        questionToolbar.backgroundView.backgroundColor = selectedTheme.toolbarColor
    }
    
    override func setupAccentColors(){
        super.setupAccentColors()
        cancelButton.tintColor = selectedAccentColor.primaryColor
        askButton.backgroundColor = selectedAccentColor.secondaryColor
        doneButton2.backgroundColor = selectedAccentColor.primaryColor
    }
    
    override func updateTheme(){
        setupThemeColors()
        setupText()
    }
    
    override func updateAccentColor(){
        setupAccentColors()
    }
    
    // MARK:- TEXT
    func setupText(){
        DispatchQueue.main.async{
            self.questionTextView.attributedPlaceholder = self.questionTextViewPlaceholderText()
            self.descriptionTextView.attributedPlaceholder = self.descriptionTextViewPlaceholderText()
            self.questionTextView.layoutIfNeeded()
            self.descriptionTextView.layoutIfNeeded()
        }
    }
    
    func questionTextViewPlaceholderText() -> NSAttributedString{
        let placeholder = "Start your question with \"What\", \"How\", \"Why\", etc"
        return NSAttributedString(string: placeholder, attributes: [
            .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            .foregroundColor: selectedTheme.secondaryPlaceholderColor
        ])
    }
    
    func descriptionTextViewPlaceholderText() -> NSAttributedString {
        let placeholder = "Optional : Provide some extra details, add images or links"
        return NSAttributedString(string: placeholder, attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: selectedTheme.secondaryPlaceholderColor
        ])
    }
    
    // MARK:- EVENT HANDLERS
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        super.imagePickerController(picker, didFinishPickingMediaWithInfo: info)
        descriptionTextView.font = .systemFont(ofSize: 16)
    }
    
    @objc func handleAsk(){
        askButton.isEnabled = false
        view.endEditing(true)
        let tagVC = TagsViewController()
        tagVC.completionHandler = submitQuestion
        navigationController?.pushViewController(tagVC, animated: true)
    }
    
    func submitQuestion(tags: [String]){
        let alert = UIAlertController(title: nil, message: "Please Wait ...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(style: .gray)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        loadingIndicator.anchor(left: alert.view.leadingAnchor, paddingLeft: 20, height: 50, width: 50)
        loadingIndicator.centerY(alert.view.centerYAnchor)
        present(alert, animated: true, completion: nil)
        
        guard let descData = descriptionTextView.attributedText.toData() else{return}
        APIService.post(question: questionTextView.text, description: descData, tags: tags){(postID) in
            self.askButton.isEnabled = true
            self.dismiss(animated: true){
                self.dismiss(animated: true)
            }
        }
    }

    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK:- EXTENSION #1: TEXT EVENTS
extension PostViewController{
    
    func updateQuestionTextViewHeight(size: CGSize){
        let questionSizeThatFits = CGSize(width: size.width, height: .infinity)
        let maxQuestionViewHeight = size.height * 0.30
        
        if(questionTextView.contentSize.height <= maxQuestionViewHeight){
            let estimatedSize = questionTextView.sizeThatFits(questionSizeThatFits)
            questionTextViewHeightContraint?.constant = estimatedSize.height
            questionTextView.isScrollEnabled = false
        }
        else{
            questionTextView.isScrollEnabled = true
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if(textView == descriptionTextView){
            textOptionsView.textViewDidChange(textView)
        }
        else{
            // Dynamic Height Of Question Text View
            updateQuestionTextViewHeight(size: view.frame.size)
            
            // Check Valid Input
            let length = questionTextView.attributedText.length
            if length > 10{
                askButton.isUserInteractionEnabled = true
                askButton.backgroundColor = selectedAccentColor.primaryColor
            }
            else{
                askButton.isUserInteractionEnabled = false
                askButton.backgroundColor = selectedAccentColor.secondaryColor
            }
        }
    }
    
    override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textView = textView as? PlaceholderTextView else {return true}
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        handlePlaceholder(textView, length: newLength)
        
        if(textView == descriptionTextView){
            let deletedText = textView.text(in: textView.toTextRange(NSRange: range))
            let isDeleted = (deletedText!.count != 0)
            return textOptionsView.changeText(textView, text, deletedText, isDeleted)
        }
        else{
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            return newText.count <= 300
        }
    }
}
