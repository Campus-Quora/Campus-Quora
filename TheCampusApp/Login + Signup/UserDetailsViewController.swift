//
//  SignUpDetailsViewController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 22/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit
import Photos

class SignUpDetailsViewController: UIViewController{
    var profileImageCell: EditDetailsImageCell?
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupColors()
        
        EditHandler.delegate = self
        tableView.register(EditDetailsImageCell.self, forCellReuseIdentifier: EditDetailsCellType.image.reusableCellIdentifier)
        tableView.register(SettingsSelectorCell.self, forCellReuseIdentifier: EditDetailsCellType.picker.reusableCellIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Additional Information"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupUI(){
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        tableView.anchor(top: safeAreaLayoutGuide.topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, left: safeAreaLayoutGuide.leadingAnchor, right: safeAreaLayoutGuide.trailingAnchor)
    }
    
    func setupColors(){
        view.backgroundColor = selectedTheme.primaryColor
        tableView.backgroundColor = selectedTheme.primaryColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return selectedTheme.statusBarStyle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    deinit {
        print("Deinit")
    }
}

extension SignUpDetailsViewController: HandleProfilePicProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // This is event handler for pressing image selection button on toolbar
    @objc func handleProfiePic(imageCell: EditDetailsImageCell){
        self.profileImageCell = imageCell
        // ======= CheckPermisson =======
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            showImagePicker()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ newStatus in
                if newStatus == PHAuthorizationStatus.authorized {
                    DispatchQueue.main.async {
                        self.showImagePicker()
                    }
                }
            })
        case .restricted:
            print("User do not have access to photo album.")
        case .denied:
            print("User has denied the permission.")
        @unknown default: break
        }
    }

    // This Displays Image Picker View
    func showImagePicker(){
        let picker = UIImagePickerController()
        picker.delegate = self
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            action in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            action in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)    }
    
    // This is called when user ends up selecting an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage,
        let compressedImage = image.jpegData(compressionQuality: 0.5)
        else {return}
        
        UpdatedDetails.shared.imageData = compressedImage
        profileImageCell?.profileImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    // This is called when user presses cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}

extension SignUpDetailsViewController: EditDepartmentCallbackProtocol{
    func didFinishPicking(_ value: String, for department: DepartmentOptions) {
        tableView.reloadData()
    }
}

extension SignUpDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return AdditionalDetailsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = UILabel()
        let view = UIView()
        view.addSubview(title)
        view.backgroundColor = selectedTheme.secondaryTextColor
        
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = selectedTheme.primaryColor
        title.text = AdditionalDetailsSection(rawValue: section)?.description
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (AdditionalDetailsSection(rawValue: section) == .ProfileImage) ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = AdditionalDetailsSection(rawValue: section) else { return 0 }
        return section.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = AdditionalDetailsSection(rawValue: indexPath.section) else {return UITableViewCell()}
        let cellDetails = section.cellDetails(for: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellDetails.cellType.reusableCellIdentifier, for: indexPath)
        
        switch cellDetails.cellType {
            case .image:
                let imageCell = cell as! EditDetailsImageCell
                imageCell.selectionStyle = .none
                imageCell.controller = self
                
            case .picker:
                let pickerCell = cell as! SettingsSelectorCell
                pickerCell.buttonLabel.text = cellDetails.placeholder
                pickerCell.selectedOptionLabel.text = cellDetails.value
            default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = AdditionalDetailsSection(rawValue: indexPath.section) else { return }
        let cellDetails = section.cellDetails(for: indexPath.row)
        switch cellDetails.cellType {
            case .picker: cellDetails.selectionHandler?()
            default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

enum AdditionalDetailsSection: Int, CaseIterable, CustomStringConvertible {
    case ProfileImage
    case Department

    var description: String {
        switch self {
            case .ProfileImage:   return ""
            case .Department:   return "Department Details"
        }
    }
    
    var numberOfRows: Int{
        switch self {
            case .ProfileImage: return ProfileImageOptions.allCases.count
            case .Department:   return DepartmentOptions.allCases.count
        }
    }
    
    func cellDetails(for index: Int) ->EditDetailsCell{
        switch self{
            case .ProfileImage:  return ProfileImageOptions(rawValue: index)!.cellDetails
            case .Department:   return DepartmentOptions(rawValue: index)!.cellDetails
        }
    }
}
