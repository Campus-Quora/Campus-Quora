//
//  Apply Theme.swift
//  Music App
//
//  Created by Yogesh Kumar on 29/04/19.
//  Copyright © 2019 Yogesh Kumar. All rights reserved.
//

import UIKit


func applyTheme(){
    // Window
    let sharedApplication = UIApplication.shared
    sharedApplication.delegate?.window??.backgroundColor = selectedTheme.primaryColor
    
    // NavigationBar
    let navBarApperance = UINavigationBar.appearance()
    navBarApperance.titleTextAttributes = [.foregroundColor : selectedTheme.primaryTextColor]
    navBarApperance.tintColor = selectedTheme.primaryColor
    navBarApperance.barTintColor = selectedTheme.primaryColor
    if #available(iOS 11.0, *) {
        navBarApperance.largeTitleTextAttributes = [.foregroundColor : selectedTheme.primaryTextColor]
    }
    
    // Tab Bar
    let tabBarAppearance = UITabBar.appearance()
    tabBarAppearance.barTintColor = selectedTheme.primaryColor
    
    // UI Label
    UILabel.appearance().textColor = selectedTheme.primaryTextColor
}

func applyAccentColor(){
    let tabBarAppearance = UITabBar.appearance()
    tabBarAppearance.tintColor = selectedAccentColor.primaryColor
    if #available(iOS 10.0, *) {
        tabBarAppearance.unselectedItemTintColor = selectedTheme.unselectedTabBarItemColor
    }
}

extension UIViewController{
    @objc func setupNavigationBar(){
        guard let navBar = navigationController?.navigationBar else {return}
        if #available(iOS 11.0, *) {
            navBar.prefersLargeTitles = true
        }
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = false
        handleNavBarColors()
    }
    
    func handleNavBarColors(){
        // Navigation Bar
        guard let navBar = navigationController?.navigationBar else {return}
        navBar.titleTextAttributes = [.foregroundColor : selectedTheme.primaryTextColor]
        navBar.tintColor = selectedTheme.primaryColor
        navBar.barTintColor = selectedTheme.primaryColor
        if #available(iOS 11.0, *) {
            navBar.largeTitleTextAttributes = [.foregroundColor : selectedTheme.primaryTextColor]
        }
        
    }
    
    @objc func didChangeColorTheme(){
        handleNavBarColors()
        updateColors()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc func updateColors(){
        
    }
}

extension UINavigationController{
    open override var childForStatusBarStyle: UIViewController?{
        return self.topViewController
    }
}


class ColorThemeObservingViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Notification Observer
        let name = Notification.Name(changeThemeKey)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeColorTheme), name: name, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return selectedTheme.statusBarStyle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

class ColorThemeObservingCollectionViewController: UICollectionViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Notification Observer
        let name = Notification.Name(changeThemeKey)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeColorTheme), name: name, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return selectedTheme.statusBarStyle
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

class ColorThemeObservingTableViewController: UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Notification Observer
        let name = Notification.Name(changeThemeKey)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeColorTheme), name: name, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return selectedTheme.statusBarStyle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}
