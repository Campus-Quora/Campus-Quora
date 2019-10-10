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
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    

    let nameTextField : UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        textField.textColor = .white
        textField.backgroundColor = .black
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 18)
        textField.autocapitalizationType = .none
        textField.tag = 0
        textField.addTarget(self, action: #selector(checkValidInput), for: .editingChanged)
        return textField
    }()
    
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        textField.backgroundColor = .black
        textField.textColor = .white
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 18)
        textField.autocapitalizationType = .none
        textField.tag = 1
        textField.addTarget(self, action: #selector(checkValidInput), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        textField.backgroundColor = .black
        textField.textColor = .white
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
        button.backgroundColor = blueColorFaint
        button.layer.cornerRadius = 5
        button.isEnabled = false
        return button
    }()
    
    let alreadyHaveAccountButton : UIButton = {
        let button = UIButton()
        let attributedText = NSMutableAttributedString(string: "Already have an account  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.7)])
        attributedText.append(NSAttributedString(string: "Log In", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : blueColorDark]))
        button.setAttributedTitle(attributedText, for: .normal)
        return button;
    }()
    
    // MARK:- Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        if #available(iOS 13, *){
            self.isModalInPresentation = true
            self.modalPresentationStyle = .fullScreen
        }
        

        
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
        
        // UI
        view.backgroundColor = .white
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
        alreadyHaveAccountButton.addTarget(self, action: #selector(changeToLogInController), for: .touchUpInside)
    }

    
    // MARK:- Triggering Methods
    @objc func changeToLogInController(){
        print("Log In")
        emailTextField.text=nil
        passwordTextField.text=nil
        nameTextField.text=nil
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignup(){
        guard let name = nameTextField.text             else {return}
        guard let email = emailTextField.text           else {return}
        guard let password = passwordTextField.text     else {return}
        print("Trying To Sign Up")
        
        SVProgressHUD.setRingThickness(5)
        SVProgressHUD.show()

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error{
                print("Signup ERROR #1 : \n\n", error)
//                let alertController = UIAlertController(title: "Invalid Email", message: "Please enter a valid Email ID", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
//                self.emailTextField.text=nil
//                self.nameTextField.text=nil
//                self.passwordTextField.text=nil
//                self.present(alertController, animated: true, completion: nil)
                
                SVProgressHUD.dismiss()

                self.firebaseErrorHandler(error: error as NSError)
                return;
            }
            
            guard let user = user?.user else{
                print("Signup Error #2 : \n\n")
                return;
            }
            
            let userData = ["userid" : user.uid,
                            "name" : name]
            
            self.db.collection("userInfo").addDocument(data: userData){ error in
                print("Saving UserInfo")
                if let error = error{
                    print("Signup ERROR #3 : \n\n", error)
                    return;
                }
                
                UserData.shared.setData(user)
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
            signupButton.backgroundColor = blueColorDark
            signupButton.isEnabled = true
        }
        else{
            signupButton.backgroundColor = blueColorFaint
            signupButton.isEnabled = false
        }
    }
    
    func firebaseErrorHandler(error: NSError){
        
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error.code){
            switch errorCode {
            case .emailAlreadyInUse :
                 let alertController = UIAlertController(title: "Email already in use.", message: "Click 'Log In' to log in.", preferredStyle: .alert)
                 alertController.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
                 alertController.addAction(UIAlertAction(title: "Log In", style: .default, handler: { (_) in
                     self.changeToLogInController()
                 }))
                 present(alertController, animated: true, completion: nil)
            case .invalidEmail:
                
                let alertController = UIAlertController(title: "Invalid Email", message: "Please enter a valid Email.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
                
                present(alertController, animated: true, completion: nil)
                
            case .networkError:
                let alertController = UIAlertController(title: "Network Error", message: "Please make sure you are connected to the Internet.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
            case .wrongPassword:
                let alertController = UIAlertController(title: "Wrong Password", message: "Please enter the correct password.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
            default:
                let alertController = UIAlertController(title: "There was an unknown error.", message: "Sorry for the inconvenience.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
            self.emailTextField.text = nil;
            self.passwordTextField.text = nil;
            self.nameTextField.text = nil;
            self.signupButton.isEnabled = false;
            self.signupButton.backgroundColor = blueColorFaint
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
