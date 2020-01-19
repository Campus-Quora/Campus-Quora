//
//  AnswerViewController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 13/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AnswerViewController: TextEditorViewController{
    var data: CompletePost?
    let cancelButton = UIButton()
    let submitButton = UIButton()
    let answerTextView = PlaceholderTextView()
    let scrollView = UIScrollView()
    weak var delegate: AnswerDelegate?
        
    // MARK:- Main Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        answerTextView.delegate = self
        textOptionsView.dataSource = answerTextView
    }
    
    override func setupNavigationBar(){
        super.setupNavigationBar()
        navigationItem.title = "Answer"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: submitButton)
    
        guard let navBar = navigationController?.navigationBar else{return}
        if #available(iOS 11.0, *) {
             navBar.prefersLargeTitles = false
        }
    }
    
    
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
        submitButton.setTitle("Submit", for: .normal)
        submitButton.tintColor = .white
        submitButton.layer.cornerRadius = 10;
        submitButton.backgroundColor = selectedAccentColor.secondaryColor
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        submitButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        submitButton.isEnabled = false
        
        // Answer TextView
        DispatchQueue.main.async{
            self.answerTextView.attributedPlaceholder = self.placeholderText()
        }
        answerTextView.textContainerInset.bottom += 24
        answerTextView.font = .systemFont(ofSize: 16)
        answerTextView.inputAccessoryView = toolbar
        answerTextView.isScrollEnabled = true
        answerTextView.showsVerticalScrollIndicator = false
        answerTextView.isEditable = true
        answerTextView.isScrollEnabled = true
        answerTextView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        answerTextView.setContentOffset(.zero, animated: false)
        
        // Scroll View
        scrollView.autoresizingMask = .flexibleHeight
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        view.addSubview(answerTextView)
        answerTextView.fillSuperView(padding: 10)
    }
    
    override func setupThemeColors(){
        super.setupThemeColors()
        view.backgroundColor = selectedTheme.primaryColor
        answerTextView.keyboardAppearance = selectedTheme.keyboardStyle
        answerTextView.textColor = selectedTheme.primaryTextColor
    }
    
    override func setupAccentColors(){
        super.setupAccentColors()
        cancelButton.tintColor = selectedAccentColor.primaryColor
        submitButton.backgroundColor = selectedAccentColor.secondaryColor
        doneButton.backgroundColor = selectedAccentColor.primaryColor
    }
    
    override func updateTheme(){
        setupThemeColors()
        DispatchQueue.main.async{
            self.answerTextView.attributedPlaceholder = self.placeholderText()
        }

    }
    
    override func updateAccentColor(){
        setupAccentColors()
    }
    
    // MARK:- UI Elements
    func placeholderText() -> NSAttributedString {
        let placeholder = "Write Your Answer Here"
        return NSAttributedString(string: placeholder, attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: selectedTheme.secondaryPlaceholderColor
        ])
    }
    
    // This is triggered when user chooses to submit
    @objc func handleSubmit(){
        print("Submit Pressed")
        
        let alert = UIAlertController(title: nil, message: "Please Wait ...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(style: .gray)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        loadingIndicator.anchor(left: alert.view.leadingAnchor, paddingLeft: 20, height: 50, width: 50)
        loadingIndicator.centerY(alert.view.centerYAnchor)
        present(alert, animated: true, completion: nil)
        guard let answerData = answerTextView.attributedText.toData() else{return}
        APIService.postAnswer(questionID: data?.postID, answerData: answerData){
            (answer: Answers) in
            answer.answerNSAString = self.answerTextView.attributedText
            self.data?.answers?.append(answer)
            DispatchQueue.main.async {
                self.dismiss(animated: true){
                    self.dismiss(animated: true){
                        self.delegate?.finishedPostingAnswer()
                    }
                }
            }
        }
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.attributedText.length > 0{
            submitButton.isEnabled = true
            submitButton.backgroundColor = selectedAccentColor.primaryColor
        }
        else{
            submitButton.isEnabled = false
            submitButton.backgroundColor = selectedAccentColor.secondaryColor
        }
        textOptionsView.textViewDidChange(textView)
    }
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        super.imagePickerController(picker, didFinishPickingMediaWithInfo: info)
        answerTextView.font = .systemFont(ofSize: 16)
    }
}
