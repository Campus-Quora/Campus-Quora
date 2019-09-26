//
//  SignupViewController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 22/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController{
    let db = Firestore.firestore()
    
    let inputPadding: CGFloat = 20
    let inputHeight: CGFloat = 40
    var stackHeight: CGFloat = 0
    var inputWidth: CGFloat = 0
    var topPadding: CGFloat = 0
    
    let header : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "Welcome To App"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.05)
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 18)
        textField.tag = 0
        textField.addTarget(self, action: #selector(checkValidInput), for: .editingChanged)
        return textField
    }()
    
    let usernameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "UserName"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.05)
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 18)
        textField.tag = 1
        textField.addTarget(self, action: #selector(checkValidInput), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.05)
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 18)
        textField.tag = 2
        textField.addTarget(self, action: #selector(checkValidInput), for: .editingChanged)
        return textField
    }()
    
    let signupButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Signup", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Constants
        stackHeight = inputHeight * 4 + inputPadding * 3
        inputWidth = view.frame.width * 0.8
        topPadding = view.frame.height * 0.4
        
        // Setup Delegates
        nameTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        view.backgroundColor = .white
        setupUI()
        
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupUI(){
        setupSignupButton()
        setupTitle()
        setupStack()
    }
    
    func setupStack(){
        let stack = UIStackView(arrangedSubviews: [nameTextField, usernameTextField, passwordTextField, signupButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = inputPadding
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.heightAnchor.constraint(equalToConstant: stackHeight),
            stack.widthAnchor.constraint(equalToConstant: inputWidth),
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding)
        ])
    }
    
    func setupTitle(){
        let height : CGFloat = view.frame.height * 0.10;
        let topPadding: CGFloat = view.frame.height * 0.10;
        let sidePadding : CGFloat = 20
        
        view.addSubview(header)
        header.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        if #available(iOS 11.0, *) {
            let layoutGuide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                header.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: topPadding),
                header.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: sidePadding),
                header.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -sidePadding)
            ])
        } else {
            NSLayoutConstraint.activate([
                header.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding),
                header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
                header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding)
            ])
        }
        
    }
    
    
    func setupSignupButton(){
        signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
    }
    
    @objc func handleSignup(){
        guard let name = nameTextField.text             else {return}
        guard let username = nameTextField.text         else {return}
        guard let password = passwordTextField.text     else {return}
        
        Auth.auth().createUser(withEmail: username, password: password) { (user, error) in
            
            if let error = error{
                print("ERROR #1 : \n\n", error)
                return;
            }
            
            let userData = ["name" : name]
            
            self.db.collection("userInfo").addDocument(data: userData){ error in
                
                if let error = error{
                    print("ERROR #2 : \n\n", error)
                    return;
                }
            }
        }
        
    }
    
    // This is triggered when Keyboards shows
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 100
            header.alpha = 0
        }
    }
    
    // This is triggered when keyboards dismisses
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            header.alpha = 1
        }
    }
    
    // This functions check if input text field in valid
    @objc func checkValidInput(){
        let isValidName = nameTextField.text?.count ?? 0 > 0
        let isValidUsername = usernameTextField.text?.count ?? 0 > 0
        let passwordLength = passwordTextField.text?.count ?? 0
        let isValidPassword = (passwordLength > 6) && (passwordLength < 16)
        if isValidName && isValidUsername && isValidPassword{
            signupButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            signupButton.isEnabled = true
        }
        else{
            signupButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            signupButton.isEnabled = false
        }
    }
}

// Move to next Text Field on pressing return key
extension SignupViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard and perform signup
            textField.resignFirstResponder()
        }
        return false
    }
}
