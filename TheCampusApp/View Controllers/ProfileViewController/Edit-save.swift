////
////  EditProfileViewController.swift
////  TheCampusApp
////
////  Created by Yogesh Kumar on 18/01/20.
////  Copyright © 2020 Harsh Motwani. All rights reserved.
////
//
//import UIKit
//import Photos
//
//enum EditDetailsCellType{
//    case textField
//    case image
//    case picker
//    case button
//}
//
//struct EditDetailsCellDetails{
//    var cellType: EditDetailsCellType
//    var selectionHandler: (() -> Void)?
//    var validationHandler: ((String) -> String)?
//}
//
//protocol EditDetailsSectionType: CustomStringConvertible {
//    var cellDetails: EditDetailsCellDetails { get }
//}
//
//enum EditDetailsSection: Int, CaseIterable, CustomStringConvertible {
//    case Info
//    case Department
//    case Interests
//
//    var description: String {
//        switch self {
//            case .Info:         return "Themes and Colors"
//            case .Department:   return "Department Details"
//            case .Interests:    return "Interests"
//        }
//    }
//}
//
//enum InfoOptions: Int, CaseIterable, EditDetailsSectionType{
//    case name
//    case email
//    case username
//
//    var cellDetails: EditDetailsCellDetails {
//        switch self {
//            case .name: return .init(cellType: .textField, selectionHandler: nil, validationHandler: EditHandler.validateUsername)
//            case .email: return .init(cellType: .textField, selectionHandler: nil, validationHandler: EditHandler.validateUsername)
//            case .username : return .init(cellType: .textField, selectionHandler: nil, validationHandler: EditHandler.validateUsername)
//        }
//    }
//
//    var description: String {
//        switch self {
//            case .name: return "Select App Theme"
//            case .email: return "Select Accent Color"
//        }
//    }
//}
//
//class EditHandler{
//    static var delegate: UIViewController?
//
//    static func validateUsername(_ username: String?)->String{
//
//    }
//
//    static func validateName(_ username: String?)->String{
//
//    }
//
//    static func validateEmail(_ username: String?)->String{
//
//    }
//
//    static func handleTheme(){
//        addPopup(viewController: ThemePopUpViewController())
//    }
//
//    static func handleAccentColor(){
//        addPopup(viewController: ColorPopUpViewController())
//    }
//
//    static func addPopup(viewController childVC: UIViewController){
//        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
//        if let navigationController = rootViewController as? UINavigationController {
//            rootViewController = navigationController.viewControllers.last
//        }
//
//        if let parentVC = rootViewController{
//            parentVC.addChild(childVC)
//            childVC.view.frame = parentVC.view.frame
//            parentVC.view.addSubview(childVC.view)
//            if let popupVC = childVC as? PopupDelegate{
//                let finalFrame = popupVC.popupView.frame
//                let finalAlpha = popupVC.dismissView.alpha
//
//                let dy : CGFloat = popupVC.height + 50//(UIScreen.main.bounds.height + popupVC.height + 50)/2
//
//                popupVC.popupView.frame = popupVC.popupView.frame.offsetBy(dx: 0, dy: dy)
//                popupVC.popupView.alpha = 0
//                popupVC.dismissView.alpha = 0
//
//                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
//                    popupVC.popupView.frame = finalFrame
//                    popupVC.popupView.alpha = 1
//                    popupVC.dismissView.alpha = finalAlpha
//                }) { (finished) in
//                    if(finished){
//                        childVC.didMove(toParent: parentVC)
//                    }
//                }
//            }
//            else{
//                childVC.didMove(toParent: parentVC)
//            }
//        }
//    }
//}
//
//
//
//class EditProfileViewController: UIViewController{
//    let cancelButton = UIButton()
//    let saveButton = UIButton()
//
//    let profileImage = RoundImageView()
//
//    let infoLabel = UILabel()
//    let passwordLabel = UILabel()
//
//    let nameField = UITextField()
//    let emailField = UITextField()
//    let usernameField = UITextField()
//    let passwordField = UITextField()
//    let confirmPasswordField = UITextField()
//    let scrollView = UIScrollView()
//
//    lazy var infoStack1 = UIStackView(arrangedSubviews: [nameField, emailField, usernameField])
//    lazy var infoStack2 = UIStackView(arrangedSubviews: [passwordField, confirmPasswordField])
//    lazy var infoStack = UIStackView(arrangedSubviews: [infoLabel, infoStack1, passwordLabel, infoStack2])
//
//    var imageData: Data?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupConstraints()
//        setupColors()
//    }
//
//    override func setupNavigationBar() {
//        super.setupNavigationBar()
//        navigationItem.largeTitleDisplayMode = .never
//        navigationItem.title = "Edit Profile"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
//        guard let navBar = navigationController?.navigationBar else{return}
//        if #available(iOS 11.0, *) {
//            navBar.prefersLargeTitles = false
//
//        }
//    }
//
//    func setupUI(){
//        // Cancel Button
//        cancelButton.setTitle("Cancel", for: .normal)
//        cancelButton.layer.cornerRadius = 10;
//        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
//        cancelButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
//
//        // Submit Button
//        saveButton.setTitle("Submit", for: .normal)
//        saveButton.layer.cornerRadius = 10;
//        saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
//        saveButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
//        saveButton.isEnabled = false
//
//        // Info Stack
//        setupTextField(textField: nameField, placeholder: "Name", value: UserData.shared.name)
//        setupTextField(textField: emailField, placeholder: "Email", value: UserData.shared.email)
//        setupTextField(textField: usernameField, placeholder: "Username", value: UserData.shared.username)
//        setupTextField(textField: passwordField, placeholder: "Password")
//        setupTextField(textField: confirmPasswordField, placeholder: "Confirm Password")
//
//        infoStack1.axis = .vertical
//        infoStack1.distribution = .fillEqually
//        infoStack1.spacing = 10
//        infoStack2.axis = .vertical
//        infoStack2.distribution = .fillEqually
//        infoStack2.spacing = 10
//
//        infoStack.axis = .vertical
//        infoStack.distribution = .fillProportionally
//        infoStack.spacing = 20
//
//        // Profile Button
//        profileImage.image = UIImage(named: "Avatar")?.resizeImage(size: CGSize(width: 100, height: 100))
//        profileImage.contentMode = .scaleAspectFit
//        profileImage.isUserInteractionEnabled = true
//        let profileImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleProfiePic))
//        profileImage.addGestureRecognizer(profileImageGestureRecognizer)
//
//        // Labels
//        [infoLabel, passwordLabel].forEach { (label) in
//            label.text = "User Info"
//            label.font = .systemFont(ofSize: 18, weight: .medium)
//        }
//    }
//
//    func setupConstraints(){
//        view.addSubview(scrollView)
//        scrollView.fillSuperView()
//        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
//
//        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
//        scrollView.addSubview(profileImage)
//        profileImage.anchor(top: scrollView.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
//        profileImage.centerX(scrollView.centerXAnchor)
//
//        scrollView.addSubview(infoStack)
//        let infoStack1Height = 50 * CGFloat(infoStack1.arrangedSubviews.count)
//        let infoStack2Height = 50 * CGFloat(infoStack2.arrangedSubviews.count)
//        infoStack1.anchor(height: infoStack1Height)
//        infoStack2.anchor(height: infoStack2Height)
//
////        [
////            infoStack1.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
////            infoStack1.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
////            infoStack2.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
////            infoStack2.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10)
////        ].forEach { (constraint) in
////                constraint.priority = .defaultHigh
////                constraint.isActive = true
////        }
//
//
//        infoStack.anchor(top: profileImage.bottomAnchor, left: safeAreaLayoutGuide.leadingAnchor, right: safeAreaLayoutGuide.trailingAnchor, paddingTop: 20)
//
//        [infoLabel, passwordLabel].forEach { label in
//            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        }
//    }
//
//    func setupColors(){
//        view.backgroundColor = selectedTheme.primaryColor
//        cancelButton.backgroundColor = selectedTheme.secondaryPlaceholderColor
//        saveButton.backgroundColor = selectedAccentColor.secondaryColor
//        saveButton.tintColor = selectedTheme.primaryColor
//        cancelButton.tintColor = selectedTheme.primaryTextColor
//        [infoLabel, passwordLabel].forEach { (label) in
//            label.backgroundColor = selectedTheme.secondaryTextColor
//            label.textColor = selectedTheme.primaryColor
//        }
//    }
//
//    func setupTextField(textField: UITextField, placeholder: String, value: String? = nil){
//        if let value = value{
//            textField.text = value
//        }
//        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : selectedTheme.primaryPlaceholderColor])
//        textField.backgroundColor = selectedTheme.secondaryColor
//        textField.textColor = selectedTheme.primaryTextColor
//        textField.borderStyle = .roundedRect
//        textField.font = .systemFont(ofSize: 18)
//        textField.autocapitalizationType = .none
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//        return selectedTheme.statusBarStyle
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setupNavigationBar()
//    }
//
//    @objc func handleCancel(){
//        navigationController?.popViewController(animated: true)
//    }
//
//    @objc func handleSave(){
//
//    }
//
//}
//
//extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    // This is event handler for pressing image selection button on toolbar
//    @objc func handleProfiePic(){
//        // ======= CheckPermisson =======
//        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
//        switch photoAuthorizationStatus {
//        case .authorized:
//            showImagePicker()
//        case .notDetermined:
//            PHPhotoLibrary.requestAuthorization({ newStatus in
//                if newStatus == PHAuthorizationStatus.authorized {
//                    DispatchQueue.main.async {
//                        self.showImagePicker()
//                    }
//                }
//            })
//        case .restricted:
//            print("User do not have access to photo album.")
//        case .denied:
//            print("User has denied the permission.")
//        @unknown default: break
//        }
//    }
//
//    // This Displays Image Picker View
//    func showImagePicker(){
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
//            action in
//            picker.sourceType = .camera
//            self.present(picker, animated: true, completion: nil)
//        }))
//        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
//            action in
//            picker.sourceType = .photoLibrary
//            self.present(picker, animated: true, completion: nil)
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)    }
//
//    // This is called when user ends up selecting an image
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let image = info[.editedImage] as? UIImage,
//        let compressedImage = image.jpegData(compressionQuality: 0.5)
//        else {return}
//
//        self.imageData = compressedImage
//        profileImage.image = image
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    // This is called when user presses cancel
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
//        picker.dismiss(animated: true, completion: nil)
//    }
//}
//
//
//
//
////extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
////    func numberOfSections(in tableView: UITableView) -> Int {
////        return SettingsSection.allCases.count
////    }
////
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        guard let section = SettingsSection(rawValue: section) else { return 0 }
////
////        switch section {
////            case .Theme: return ThemeOptions.allCases.count
////        }
////    }
////
////    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
////        let view = UIView()
////        view.backgroundColor = selectedTheme.secondaryColor
////        let title = UILabel()
////        title.font = UIFont.boldSystemFont(ofSize: 16)
////        title.textColor = selectedTheme.secondaryTextColor
////        title.text = SettingsSection(rawValue: section)?.description
////        view.addSubview(title)
////        title.translatesAutoresizingMaskIntoConstraints = false
////        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
////        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
////
////        return view
////    }
////
////    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
////        return 40
////    }
////
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
////
////        var cellDetails: SettingCellDetails?
////        var desc: String?
////
////        switch section {
////            case .Theme:
////                let leave = ThemeOptions(rawValue: indexPath.row)
////                cellDetails = leave?.cellDetails
////                desc = leave?.description
////        }
////
////        guard let details = cellDetails else {return UITableViewCell()}
////        switch details.cellType{
////            case .button:
////                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsViewController.settingsButtonCellID, for: indexPath) as! SettingsButtonCell
////                cell.buttonLabel.text = desc
////
////                return cell
////
////            case .toggle:
////                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsViewController.settingsToggleCellID, for: indexPath) as! SettingsToggleCell
//////                cell.buttonLabel.text = desc
////                return cell
////
////            case .selector:
////                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsViewController.settingsSelectorCellID, for: indexPath) as! SettingsSelectorCell
////                cell.buttonLabel.text = desc
////                return cell
////
////            case .color:
////                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsViewController.settingsColorCellID, for: indexPath) as! SettingsColorCell
////                cell.buttonLabel.text = desc
////                return cell
////        }
////    }
////
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
////
////        switch section {
////            case .Theme:
////                let theme = ThemeOptions(rawValue: indexPath.row)
////                theme?.cellDetails.eventHandler?()
////                print(ThemeOptions(rawValue: indexPath.row)!.description)
////        }
////        tableView.deselectRow(at: indexPath, animated: true)
////    }
////}
////
////extension UITableView {
////    //set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
////    func setAndLayoutTableFooterView(footer: UIView) {
////        self.tableFooterView = footer
////        footer.setNeedsLayout()
////        footer.layoutIfNeeded()
////        footer.frame.size = footer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
////        self.tableFooterView = footer
////    }
////}
////



//func setupConstraints(){
//        view.addSubview(scrollView)
//        scrollView.fillSuperView()
//        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
//
//        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
//        scrollView.addSubview(profileImage)
//        profileImage.anchor(top: scrollView.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
//        profileImage.centerX(scrollView.centerXAnchor)
//
//        scrollView.addSubview(infoStack)
//        let infoStack1Height = 50 * CGFloat(infoStack1.arrangedSubviews.count)
//        let infoStack2Height = 50 * CGFloat(infoStack2.arrangedSubviews.count)
//        infoStack1.anchor(height: infoStack1Height)
//        infoStack2.anchor(height: infoStack2Height)
//
////        [
////            infoStack1.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
////            infoStack1.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
////            infoStack2.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
////            infoStack2.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10)
////        ].forEach { (constraint) in
////                constraint.priority = .defaultHigh
////                constraint.isActive = true
////        }
//
//
//        infoStack.anchor(top: profileImage.bottomAnchor, left: safeAreaLayoutGuide.leadingAnchor, right: safeAreaLayoutGuide.trailingAnchor, paddingTop: 20)
//
//        [infoLabel, passwordLabel].forEach { label in
//            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        }
//    }
//
//// Info Stack
//setupTextField(textField: nameField, placeholder: "Name", value: UserData.shared.name)
//setupTextField(textField: emailField, placeholder: "Email", value: UserData.shared.email)
//setupTextField(textField: usernameField, placeholder: "Username", value: UserData.shared.username)
//setupTextField(textField: passwordField, placeholder: "Password")
//setupTextField(textField: confirmPasswordField, placeholder: "Confirm Password")
//
//infoStack1.axis = .vertical
//infoStack1.distribution = .fillEqually
//infoStack1.spacing = 10
//infoStack2.axis = .vertical
//infoStack2.distribution = .fillEqually
//infoStack2.spacing = 10
//
//infoStack.axis = .vertical
//infoStack.distribution = .fillProportionally
//infoStack.spacing = 20
//
//// Profile Button
//profileImage.image = UIImage(named: "Avatar")?.resizeImage(size: CGSize(width: 100, height: 100))
//profileImage.contentMode = .scaleAspectFit
//profileImage.isUserInteractionEnabled = true
//let profileImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleProfiePic))
//profileImage.addGestureRecognizer(profileImageGestureRecognizer)
//
//// Labels
//[infoLabel, passwordLabel].forEach { (label) in
//    label.text = "User Info"
//    label.font = .systemFont(ofSize: 18, weight: .medium)
//}
//
//let profileImage = RoundImageView()
//
//let infoLabel = UILabel()
//let passwordLabel = UILabel()
//
//let nameField = UITextField()
//let emailField = UITextField()
//let usernameField = UITextField()
//let passwordField = UITextField()
//let confirmPasswordField = UITextField()
//let scrollView = UIScrollView()
//
//lazy var infoStack1 = UIStackView(arrangedSubviews: [nameField, emailField, usernameField])
//lazy var infoStack2 = UIStackView(arrangedSubviews: [passwordField, confirmPasswordField])
//lazy var infoStack = UIStackView(arrangedSubviews: [infoLabel, infoStack1, passwordLabel, infoStack2])
//

//func setupTextField(textField: UITextField, placeholder: String, value: String? = nil){
//    if let value = value{
//        textField.text = value
//    }
//    textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : selectedTheme.primaryPlaceholderColor])
//    textField.backgroundColor = selectedTheme.secondaryColor
//    textField.textColor = selectedTheme.primaryTextColor
//    textField.borderStyle = .roundedRect
//    textField.font = .systemFont(ofSize: 18)
//    textField.autocapitalizationType = .none
//}
//        [infoLabel, passwordLabel].forEach { (label) in
//            label.backgroundColor = selectedTheme.secondaryTextColor
//            label.textColor = selectedTheme.primaryColor
//        }
