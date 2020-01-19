//
//  Settings Handler.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 12/10/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

class SettingsHandler{
    static var delegate: UIViewController?
    static func handleTheme(){
        addPopup(viewController: ThemePopUpViewController())
    }
    
    static func handleAccentColor(){
        addPopup(viewController: ColorPopUpViewController())
    }
    
    static func addPopup(viewController childVC: UIViewController){
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.last
        }
        
        if let parentVC = rootViewController{
            parentVC.addChild(childVC)
            childVC.view.frame = parentVC.view.frame
            parentVC.view.addSubview(childVC.view)
            if let popupVC = childVC as? PopupDelegate{
                let finalFrame = popupVC.popupView.frame
                let finalAlpha = popupVC.dismissView.alpha
                
                let dy : CGFloat = popupVC.height + 50//(UIScreen.main.bounds.height + popupVC.height + 50)/2
                
                popupVC.popupView.frame = popupVC.popupView.frame.offsetBy(dx: 0, dy: dy)
                popupVC.popupView.alpha = 0
                popupVC.dismissView.alpha = 0
                
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    popupVC.popupView.frame = finalFrame
                    popupVC.popupView.alpha = 1
                    popupVC.dismissView.alpha = finalAlpha
                }) { (finished) in
                    if(finished){
                        childVC.didMove(toParent: parentVC)
                    }
                }
            }
            else{
                childVC.didMove(toParent: parentVC)
            }
        }
    }
}

class ThemePopUpViewController: PopupViewController, UITableViewDelegate, UITableViewDataSource{
    private let cellID = "themePopUpCellID"
    
    let tableView = UITableView()
    
    override func setupColors() {
        super.setupColors()
        tableView.backgroundColor = selectedTheme.primaryColor
    }
    
    override func setupView() {
        super.setupView()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
    }
    
    override func setupContraints() {
        super.setupContraints()
        popupView.addSubview(tableView)
        tableView.anchor(top: headerView.bottomAnchor, bottom: popupView.bottomAnchor ,left: popupView.leadingAnchor, right: popupView.trailingAnchor)
    }
    
    override func viewDidLoad() {
        headerLabel.text = "Choose Theme"
        height = 200
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: UITableViewCell!
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellID) {
            cell = dequeuedCell
        }
        else{
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        cell.textLabel?.text = themes[indexPath.row].name
        cell.textLabel?.font = .systemFont(ofSize: 16)
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = selectedTheme.primaryTextColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTheme = themes[indexPath.row]
        setupColors()
        tableView.reloadData()
        applyTheme()
        let name = Notification.Name(changeThemeKey)
        NotificationCenter.default.post(name: name, object: nil)
        self.removeAnimate()
    }
}

class ColorPopUpViewController: PopupViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    private let cellID = "accentColorPopUpCellID"
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return cv
    }()
    
    override func setupColors() {
        super.setupColors()
        collectionView.backgroundColor = selectedTheme.primaryColor
    }
    
    override func setupContraints() {
        super.setupContraints()
        popupView.addSubview(collectionView)
        collectionView.anchor(top: headerView.bottomAnchor, bottom: popupView.bottomAnchor ,left: popupView.leadingAnchor, right: popupView.trailingAnchor)
    }
    
    override func viewDidLoad() {
        headerLabel.text = "Choose Accent Color"
        height = 220
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accentColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.contentView.layer.cornerRadius = cell.contentView.frame.size.width/2
        cell.contentView.backgroundColor = accentColors[indexPath.item].primaryColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAccentColor = accentColors[indexPath.row]
        setupColors()
        applyTheme()
        let name = Notification.Name(changeAccentColorKey)
        NotificationCenter.default.post(name: name, object: nil)
        self.removeAnimate()
    }
}
