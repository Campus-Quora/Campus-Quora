//
//  SettingsViewController.swift
//  Music App
//
//  Created by Yogesh Kumar on 27/04/19.
//  Copyright © 2019 Yogesh Kumar. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: ColorThemeObservingTableViewController{
    lazy var backButton: UIButton = {
        let button = UIButton()
        let size = CGSize(width: 30, height: 30)
        let image = UIImage(named: "Cancel")?.resizeImage(size: size).withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(SettingsViewController.dismissVC), for: .touchUpInside)
        return button
    }()
    
    let footer = SettingsFooter()
    
    @objc func dismissVC(){
        navigationController?.popViewController(animated: true)
    }

    static let settingsButtonCellID = "settingsButtonCellID"
    static let settingsToggleCellID = "settingsToggleCellID"
    static let settingsSelectorCellID = "settingsPopupCellID"
    static let settingsColorCellID = "settingsColorCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColors()
        
        // Register Cells
        tableView.register(SettingsButtonCell.self, forCellReuseIdentifier: SettingsViewController.settingsButtonCellID)
        tableView.register(SettingsToggleCell.self, forCellReuseIdentifier: SettingsViewController.settingsToggleCellID)
        tableView.register(SettingsSelectorCell.self, forCellReuseIdentifier: SettingsViewController.settingsSelectorCellID)
        tableView.register(SettingsColorCell.self, forCellReuseIdentifier: SettingsViewController.settingsColorCellID)
    
        SettingsHandler.delegate = self
        
        // Footer
        footer.setUp()
        tableView.setAndLayoutTableFooterView(footer: footer)
    }
    
    override func setupNavigationBar(){
        super.setupNavigationBar()
        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    override func updateTheme() {
        tableView.backgroundColor = selectedTheme.primaryColor
        footer.setupThemeColors()
    }
    
    override func updateAccentColor() {
        backButton.tintColor = selectedAccentColor.primaryColor
    }

    func setupColors(){
        tableView.backgroundColor = selectedTheme.primaryColor
        backButton.tintColor = selectedAccentColor.primaryColor
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        
        switch section {
            case .Theme: return ThemeOptions.allCases.count
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = selectedTheme.secondaryColor
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = selectedTheme.secondaryTextColor
        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        var cellDetails: SettingCellDetails?
        var desc: String?
        
        switch section {
            case .Theme:
                let leave = ThemeOptions(rawValue: indexPath.row)
                cellDetails = leave?.cellDetails
                desc = leave?.description
        }
        
        guard let details = cellDetails else {return UITableViewCell()}
        switch details.cellType{
            case .button:
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsViewController.settingsButtonCellID, for: indexPath) as! SettingsButtonCell
                cell.buttonLabel.text = desc
                
                return cell
            
            case .toggle:
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsViewController.settingsToggleCellID, for: indexPath) as! SettingsToggleCell
//                cell.buttonLabel.text = desc
                return cell
            
            case .selector:
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsViewController.settingsSelectorCellID, for: indexPath) as! SettingsSelectorCell
                cell.buttonLabel.text = desc
                return cell
            
            case .color:
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsViewController.settingsColorCellID, for: indexPath) as! SettingsColorCell
                cell.buttonLabel.text = desc
                return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        
        switch section {
            case .Theme:
                let theme = ThemeOptions(rawValue: indexPath.row)
                theme?.cellDetails.eventHandler?()
                print(ThemeOptions(rawValue: indexPath.row)!.description)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UITableView {
    //set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
    func setAndLayoutTableFooterView(footer: UIView) {
        self.tableFooterView = footer
        footer.setNeedsLayout()
        footer.layoutIfNeeded()
        footer.frame.size = footer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.tableFooterView = footer
    }
}



//extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{

//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return settings.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return settings[section].list.count
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
//        if let cell = cell as? SettingsCell{
//            cell.setupCell(data: settings[indexPath.section].list[indexPath.item])
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width: CGFloat = view.frame.width - 20
//        let height: CGFloat = 60
//        return CGSize(width: width, height: height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        settings[indexPath.section].list[indexPath.row].function()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//}
//
//extension UINavigationController{
//
//}
