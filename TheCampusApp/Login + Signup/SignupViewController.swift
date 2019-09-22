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
    
    let usernameTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nameTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let signupButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupUI()
    }
    
    func setupUI(){
        setupStack()
        setupNameTextField()
        setupUsernameTextField()
        setupPasswordTextField()
        setupSignupButton()
    }
    
    func setupStack(){
        let stack = UIStackView(arrangedSubviews: [nameTextField, usernameTextField, passwordTextField])
        stack.alignment = .fill
        stack.axis = .vertical
        
        view.addSubview(stack)
    }
    
    func setupNameTextField(){
        view.addSubview(nameTextField)
        
    }
    
    func setupUsernameTextField(){
        view.addSubview(usernameTextField)
    }
    
    func setupPasswordTextField(){
        view.addSubview(passwordTextField)
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
    
}
