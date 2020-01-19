//
//  SignupViewController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 22/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

//            let userData: [String: Any] = [
//                "name" : name,
//                "profilePicURL": "",
//                "followerCount": 0,
//                "followingCount": 0,
//                "likesCount" : 0,
//                "questionsCount": 0,
//                "answersCount": 0,
//            ]

class SignupViewController: UIViewController{
    // MARK:- Constants
    
    
    let inputPadding: CGFloat = 20
    let inputHeight: CGFloat = 40
    var stackHeight: CGFloat = 0
    var inputWidth: CGFloat = 0
    var topPadding: CGFloat = 0
    let db = Firestore.firestore()
    
    // MARK:- UI Elements
    
    let header : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "Sign Up"
        label.textColor = selectedTheme.primaryTextColor
        label.textAlignment = .center
        return label
    }()
    
    let nameTextField : UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [.foregroundColor : selectedTheme.primaryPlaceholderColor])
        textField.textColor = selectedTheme.primaryTextColor
        textField.backgroundColor = selectedTheme.secondaryColor
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 18)
        textField.autocapitalizationType = .none
        textField.tag = 0
        textField.addTarget(self, action: #selector(checkValidInput), for: .editingChanged)
        return textField
    }()
    
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [.foregroundColor : selectedTheme.primaryPlaceholderColor])
        textField.backgroundColor = selectedTheme.secondaryColor
        textField.textColor = selectedTheme.primaryTextColor
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 18)
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.tag = 1
        textField.addTarget(self, action: #selector(checkValidInput), for: .editingChanged)
        return textField
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
    
    let signupButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = selectedAccentColor.secondaryColor
        button.layer.cornerRadius = 5
        button.isEnabled = false
        return button
    }()
    
    let alreadyHaveAccountButton : UIButton = {
        let button = UIButton()
        let attributedText = NSMutableAttributedString(string: "Already have an account  ", attributes: [.font: UIFont.systemFont(ofSize: 18), .foregroundColor : selectedTheme.secondaryTextColor])
        attributedText.append(NSAttributedString(string: "Log In", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .medium), .foregroundColor : selectedAccentColor.primaryColor]))
        button.setAttributedTitle(attributedText, for: .normal)
        return button;
    }()
    
    // MARK:- Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = selectedTheme.primaryColor
        navigationController?.isNavigationBarHidden = true
//        if #available(iOS 13, *){
//            self.isModalInPresentation = true
//            self.modalPresentationStyle = .fullScreen
//        }
        
        // Set Constants
        stackHeight = inputHeight * 4 + inputPadding * 3
        inputWidth = view.frame.width * 0.8
        topPadding = view.frame.height * 0.4
        
        // Setup Delegates
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // Handle Keyboard Events
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        setupUI()
    }
    
    // MARK:- Setup UI Methods
    func setupUI(){
        setupHeader()
        setupStack()
        setupFooter()
    }
    
    func setupHeader(){
        let height : CGFloat = view.frame.height * 0.10;
        let topPadding: CGFloat = view.frame.height * 0.10;
        let sidePadding : CGFloat = 20
        
        view.addSubview(header)
        
        if #available(iOS 11.0, *) {
            let layoutGuide = view.safeAreaLayoutGuide
            header.anchor(top: layoutGuide.topAnchor, left: layoutGuide.leadingAnchor, right: layoutGuide.trailingAnchor, paddingTop: topPadding, paddingLeft: sidePadding, paddingRight: sidePadding, height: height)
        } else {
            header.anchor(top: view.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: topPadding, paddingLeft: sidePadding, paddingRight: sidePadding, height: height)
        }
        
    }
    
    func setupStack(){
        let stack = UIStackView(arrangedSubviews: [nameTextField, emailTextField, passwordTextField, signupButton])
        signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = inputPadding
        
        view.addSubview(stack)
        stack.anchor(top: view.topAnchor, paddingTop: topPadding, height: stackHeight, width: inputWidth)
        stack.centerX(view.centerXAnchor)
    }
    
    func setupFooter(){
        view.addSubview(alreadyHaveAccountButton)
        if #available(iOS 11.0, *) {
            let layoutGuide = view.safeAreaLayoutGuide
            alreadyHaveAccountButton.anchor(bottom: layoutGuide.bottomAnchor, left: layoutGuide.leadingAnchor, right: layoutGuide.trailingAnchor, paddingBottom: 5, paddingLeft: 10, paddingRight: 10, height: 50)
        } else {
            alreadyHaveAccountButton.anchor(bottom: view.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingBottom: 5, paddingLeft: 10, paddingRight: 10, height: 50)
        }
        alreadyHaveAccountButton.addTarget(self, action: #selector(handleAlreadyHaveAccountButton), for: .touchUpInside)
    }

    
    // MARK:- Triggering Methods
    @objc func handleAlreadyHaveAccountButton(){
        changeToLogInController()
    }
    func changeToLogInController(loginEmail: String? = nil){
        emailTextField.text = ""
        passwordTextField.text = ""
        nameTextField.text = ""
        self.signupButton.isEnabled = false;
        self.signupButton.backgroundColor = selectedAccentColor.secondaryColor
        if let email = loginEmail{
            if let loginVC = self.navigationController?.viewControllers.first as? LoginViewController{
                loginVC.emailTextField.text = email
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignup(){
        view.endEditing(true)
        self.signupButton.isEnabled = false;
        self.signupButton.backgroundColor = selectedAccentColor.secondaryColor
        
        guard let name = nameTextField.text             else {return}
        guard let email = emailTextField.text           else {return}
        guard let password = passwordTextField.text     else {return}
        print("Trying To Sign Up")
        
        SVProgressHUD.setRingThickness(5)
        SVProgressHUD.show()

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error{
                print("Signup ERROR #1 : \n\n", error)
                SVProgressHUD.dismiss()
                self.handleSignupError(error)
                return;
            }

            guard let user = user?.user else{
                print("Signup Error #2 : \n\n")
                return;
            }

            UserData.shared.setData(user)
            UserData.shared.name = name
            let userData = try! UserData.shared.asDictionary()

            APIService.userInfoCollection.document(UserData.shared.uid!).setData(userData){ error in
                print("Saving UserInfo")
                if let error = error{
                    print("Signup ERROR #3 : \n\n", error)
                    return;
                }

                // Go to Main Tab Bar Controller
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    if let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController{
                        mainTabBarController.setupViewControllers()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func handleSignupError(_ error: Error){
        if let errorCode = AuthErrorCode(rawValue: error._code){
            var errorTitle: String = ""
            var errorMessage: String = ""
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            var actions = [UIAlertAction]()
            switch(errorCode){
                case .invalidEmail, .invalidSender, .invalidRecipientEmail:
                    errorTitle = "Invalid Email"
                    errorMessage = "Please enter a valid Email."
                    actions.append(defaultAction)
                
                case .emailAlreadyInUse:
                    errorTitle = "User Already Registered"
                    errorMessage = "A user is already registered with this Email. Click 'Login' to use this account"
                    
                    let action1 = UIAlertAction(title: "Try Again", style: .cancel, handler: { (_) in
                        self.emailTextField.text = "";
                        self.passwordTextField.text = "";
                    })
                    
                    let action2 = UIAlertAction(title: "Log In", style: .default, handler: { (_) in
                        let email = self.emailTextField.text
                        
                        self.nameTextField.text = ""
                        self.emailTextField.text = "";
                        self.passwordTextField.text = "";
                        
                        self.changeToLogInController(loginEmail: email)
                    })
                    
                    actions.append(action1)
                    actions.append(action2)
                
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
        let isValidEmail = emailTextField.text?.count ?? 0 > 0
        let passwordLength = passwordTextField.text?.count ?? 0
        let isValidPassword = (passwordLength >= 6) && (passwordLength <= 16)
        if isValidName && isValidEmail && isValidPassword{
            signupButton.backgroundColor = selectedAccentColor.primaryColor
            signupButton.isEnabled = true
        }
        else{
            signupButton.backgroundColor = selectedAccentColor.secondaryColor
            signupButton.isEnabled = false
        }
    }
}

// MARK:- Extension #1
extension SignupViewController : UITextFieldDelegate{
    
    // Move to next Text Field on pressing return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard and perform signup
            textField.resignFirstResponder()
            handleSignup()
        }
        return false
    }
}
