//
//  ProfileViewController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 27/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

//visibleHeight = UIScreen.main.nativeBounds.height/UIScreen.main.nativeScale - navigationController!.navigationBar.frame.size.height - tabBarController!.tabBar.frame.size.height - UIApplication.shared.statusBarFrame.height

import UIKit
import Firebase

class ProfileViewController: ColorThemeObservingViewController{
    let headerID = "profileHeaderID"
    let cellID = "profileCellID"
    
    let iconNames = ["Q", "A", "Bookmark", "Like"]
    let titles = ["My Questions", "My Answers", "Bookmarks", "Liked Posts"]
    
    var maxAnswerSize: CGSize!
    var maxQuestionSize: CGSize!
    var estimatedWidth: CGFloat!
    let profileTableView = UITableView(frame: .zero, style: .grouped)
    let settingsButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateAccentColor()
        updateTheme()
        
        // This is used to force collectionView to stick to safe layout
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.contentInsetAdjustmentBehavior = .always
        profileTableView.register(ProfileHeader.self, forHeaderFooterViewReuseIdentifier: headerID)
        profileTableView.register(ProfileCell.self, forCellReuseIdentifier: cellID)
        profileTableView.estimatedSectionHeaderHeight = 300
    }
    
    override func setupNavigationBar(){
        super.setupNavigationBar()
        navigationItem.title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
    }
    
    override func updateAccentColor() {
        settingsButton.tintColor = selectedAccentColor.primaryColor
    }
    
    override func updateTheme() {
        profileTableView.backgroundColor = selectedTheme.primaryColor
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func launchSettings(){
        let settingsVC = SettingsViewController()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func setupUI(){
        let size = CGSize(width: 30, height: 30)
        let image = UIImage(named: "Settings")?.resizeImage(size: size).withRenderingMode(.alwaysTemplate)
        settingsButton.setImage(image, for: .normal)
        settingsButton.addTarget(self, action: #selector(launchSettings), for: .touchUpInside)
        
        view.addSubview(profileTableView)
        profileTableView.fillSuperView()
    }
    
    @objc func handleEditProfile(){
        let editProfileVC = EditProfileViewController()
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        if let profileCell = cell as? ProfileCell{
            profileCell.setupData(titles[indexPath.row], iconNames[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as? ProfileHeader else {return UITableViewHeaderFooterView()}
        header.controller = self
        return header
    }
}
