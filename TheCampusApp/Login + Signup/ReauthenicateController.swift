//
//  SignupViewController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 22/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import Firebase

class ReauthenticateViewController: UIViewController, UITextFieldDelegate{
    // MARK:- Constants
    let inputPadding: CGFloat = 20
    let inputHeight: CGFloat = 40
    var stackHeight: CGFloat = 0
    var inputWidth: CGFloat = 0
    var topPadding: CGFloat = 0
    var callback: (()->Void)?
    
    // MARK:- UI Elements
    
    let header : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let string1 = NSAttributedString(string: "Re Authentication\n\n", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)])
        let string2 = NSAttributedString(string: "Please Enter Your Current Password", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)])
        let mutableStr = NSMutableAttributedString(attributedString: string1)
        mutableStr.append(string2)
        label.attributedText = mutableStr
        label.textColor = selectedTheme.primaryTextColor
        label.textAlignment = .center
        return label
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [.foregroundColor : selectedTheme.primaryPlaceholderColor])
        textField.backgroundColor = selectedTheme.secondaryColor
        textField.textColor = selectedTheme.primaryTextColor
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 18)
        textField.tag = 2
        textField.addTarget(self, action: #selector(checkValidInput), for: .editingChanged)
        return textField
    }()
    
    let confirmButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = selectedAccentColor.secondaryColor
        button.layer.cornerRadius = 5
        button.isEnabled = false
        return button
    }()
    
    // MARK:- Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = selectedTheme.primaryColor
        navigationController?.isNavigationBarHidden = true
        
        // Set Constants
        stackHeight = inputHeight * 2 + inputPadding * 1
        inputWidth = view.frame.width * 0.8
        topPadding = view.frame.height * 0.4
        
        // Setup Delegates
        passwordTextField.delegate = self
        
        // Handle Keyboard Events
        self.hideKeyboardWhenTappedAround()
        setupUI()
    }
    
    // MARK:- Setup UI Methods
    func setupUI(){
        setupHeader()
        setupStack()
    }
    
    func setupHeader(){
        let topPadding: CGFloat = view.frame.height * 0.10;
        let sidePadding : CGFloat = 20
        
        view.addSubview(header)
        let layoutGuide = view.safeAreaLayoutGuide
        header.anchor(top: layoutGuide.topAnchor, left: layoutGuide.leadingAnchor, right: layoutGuide.trailingAnchor, paddingTop: topPadding, paddingLeft: sidePadding, paddingRight: sidePadding)
    }
    
    func setupStack(){
        let stack = UIStackView(arrangedSubviews: [passwordTextField, confirmButton])
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = inputPadding
        
        view.addSubview(stack)
        stack.anchor(top: header.bottomAnchor, paddingTop: 20, height: stackHeight, width: inputWidth)
        stack.centerX(view.centerXAnchor)
    }

    @objc func handleConfirm(){
        view.endEditing(true)
        self.confirmButton.isEnabled = false;
        self.confirmButton.backgroundColor = selectedAccentColor.secondaryColor
        
        guard let password = passwordTextField.text     else {return}
        
        let alert = UIAlertController(title: nil, message: "Reauthenticating Please Wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(style: .gray)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        loadingIndicator.anchor(left: alert.view.leadingAnchor, paddingLeft: 20, height: 50, width: 50)
        loadingIndicator.centerY(alert.view.centerYAnchor)
        present(alert, animated: true, completion: nil)

        APIService.reauthenticate(with: password){ [weak self] error in
            guard let self = self else{return}
            self.dismiss(animated: true, completion: nil)
            if let error = error{
                print("Reauthentication ERROR #1 : \n\n", error)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else{return}
                    self.handleReuthenticationError(error)
                }
            }
            else{
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else{return}
                    self.dismiss(animated: true){
                        self.callback?()
                    }
                }
            }
        }
    }
    
    func handleReuthenticationError(_ error: Error){
        if let errorCode = AuthErrorCode(rawValue: error._code){
            var errorTitle: String = ""
            var errorMessage: String = ""
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel){ _ in
                DispatchQueue.main.async {
                    self.checkValidInput()
                }
            }
            
            var actions = [UIAlertAction]()
            switch(errorCode){
                case .wrongPassword:
                    errorTitle = "Wrong Password"
                    errorMessage = "Please enter the correct password."
                    actions.append(defaultAction)
                
                case .userDisabled:
                    errorTitle = "Your account has been disabled"
                    errorMessage = "Please Contact Support"
                    actions.append(defaultAction)
                
                case .networkError:
                    errorTitle = "Network Error"
                    errorMessage = "Please make sure you are connected to the Internet."
                    actions.append(defaultAction)
                
                default:
                    errorTitle =  "Unknown error occurred"
                    errorMessage =  "Sorry for the inconvenience."
                    actions.append(defaultAction)
            }
            
            let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
            
            actions.forEach({ (action) in
                alertController.addAction(action)
            })
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // This functions check if input text field in valid
    @objc func checkValidInput(){
        let passwordLength = passwordTextField.text?.count ?? 0
        let isValidPassword = (passwordLength >= 6) && (passwordLength <= 16)
        if isValidPassword{
            confirmButton.backgroundColor = selectedAccentColor.primaryColor
            confirmButton.isEnabled = true
        }
        else{
            confirmButton.backgroundColor = selectedAccentColor.secondaryColor
            confirmButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        handleConfirm()
        return false
    }
}

//    // This is triggered when Keyboards shows
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if self.view.frame.origin.y == 0 {
//            self.view.frame.origin.y -= 100
//            header.alpha = 0
//        }
//    }
//
//    // This is triggered when keyboards dismisses
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//            header.alpha = 1
//        }
//    }
    
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
