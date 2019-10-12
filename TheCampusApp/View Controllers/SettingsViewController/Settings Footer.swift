//
//  SettingsFooter.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 11/10/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import Firebase

class SettingsFooter: UIView{
    
    let signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(handleSignOut), for: .touchUpInside)
        return button
    }()
    
    let deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Account", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    func setUp() {
        self.backgroundColor = selectedTheme.secondaryColor
        let stack = UIStackView(arrangedSubviews: [signOutButton, deleteAccountButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        addSubview(stack)
        stack.fillSuperView(padding: 10)
        setupThemeColors()
    }
    
    func setupThemeColors(){
        signOutButton.setTitleColor(selectedTheme.primaryTextColor, for: .normal)
    }
    
    @objc func handleSignOut() {
        let alertController = UIAlertController(title: "Sign Out?", message: "Are you sure you want to Sign Out?", preferredStyle: .alert)
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        rootViewController?.present(alertController, animated: true, completion: nil)

        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            do{
                try Auth.auth().signOut()
                let loginController = LoginViewController()
                let navController = UINavigationController(rootViewController: loginController)
                if let tabBarController = rootViewController as? UITabBarController {
                    tabBarController.selectedIndex = 0
                }
                rootViewController?.present(navController, animated: true, completion: nil)
            } catch let signOutError {
                print("Failed to Sign Out: ", signOutError)
            }
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
    @objc func handleDeleteAccount(){
        let alertController = UIAlertController(title: "Sign Out?", message: "Are you sure you want to Sign Out?", preferredStyle: .alert)
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        rootViewController?.present(alertController, animated: true, completion: nil)
        
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            
            // TODO: Present a screen which asks for password for confirmation for deleting account
            
            let user = Auth.auth().currentUser
            user?.delete { error in
                if let error = error {
                    print("Account Deletion Error", error)
                } else {
                    let loginController = LoginViewController()
                    let navController = UINavigationController(rootViewController: loginController)
                    if let tabBarController = rootViewController as? UITabBarController {
                        tabBarController.selectedIndex = 0
                    }
                    rootViewController?.present(navController, animated: true, completion: nil)
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
}
