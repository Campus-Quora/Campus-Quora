//
//  EditProfileViewController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 18/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit
import Photos

class EditDetailsTextCell: UITableViewCell, UITextFieldDelegate{
    let textField = UITextField()
    var type1: InfoOptions?
    var type2: PasswordOptions?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textField.backgroundColor = selectedTheme.secondaryColor
        textField.textColor = selectedTheme.primaryTextColor
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 18)
        textField.autocapitalizationType = .none
        textField.delegate = self
        addSubview(textField)
        textField.fillSuperView(padding: 7)
    }
    
    func setup(placeholder: String, isSecure: Bool, value: String? = nil){
        if let value = value{ textField.text = value }
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : selectedTheme.primaryPlaceholderColor])
        if(isSecure){
            textField.isSecureTextEntry = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if((type1) != nil){
            switch(type1){
                case .name:     UpdatedDetails.shared.name = textField.text
                case .email:    UpdatedDetails.shared.email = textField.text
                case .username: UpdatedDetails.shared.username = textField.text
                case .none: break
            }
        }
        else{
            switch type2{
                case .password:         UpdatedDetails.shared.password = textField.text
                case .confirmPassword:  UpdatedDetails.shared.confirmedPassword = textField.text
                case .none: break
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EditDetailsImageCell: UITableViewCell{
    let profileImage = RoundImageView()
    weak var controller: EditProfileViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        profileImage.image = UIImage(named: "Avatar")?.resizeImage(size: CGSize(width: 100, height: 100))
        profileImage.contentMode = .scaleAspectFit
        profileImage.isUserInteractionEnabled = true
        let profileImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleProfilePic))
        profileImage.addGestureRecognizer(profileImageGestureRecognizer)
        
        addSubview(profileImage)
        profileImage.centerX(centerXAnchor)
        profileImage.anchor(top: topAnchor, bottom: bottomAnchor, paddingTop: 10, paddingBottom: 10)
    }
    
    @objc func handleProfilePic(){
        controller?.handleProfiePic(imageCell: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct UpdatedDetails{
    var name: String?
    var email: String?
    var username: String?
    var password: String?
    var confirmedPassword: String?
    var department: String?
    var programme: String?
    var year: String?
    var imageData: Data?
    
    static var shared = UpdatedDetails()
}

class EditProfileViewController: UIViewController{
    let cancelButton = UIButton()
    let saveButton = UIButton()
    var profileImageCell: EditDetailsImageCell?
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialData()
        setupUI()
        setupColors()
        
        EditHandler.delegate = self
        tableView.register(EditDetailsImageCell.self, forCellReuseIdentifier: EditDetailsCellType.image.reusableCellIdentifier)
        tableView.register(EditDetailsTextCell.self, forCellReuseIdentifier: EditDetailsCellType.textField.reusableCellIdentifier)
        tableView.register(SettingsSelectorCell.self, forCellReuseIdentifier: EditDetailsCellType.picker.reusableCellIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func setupInitialData(){
        UpdatedDetails.shared.name = UserData.shared.name
        UpdatedDetails.shared.username = UserData.shared.username
        UpdatedDetails.shared.email = UserData.shared.email
        UpdatedDetails.shared.department = UserData.shared.department
        UpdatedDetails.shared.programme = UserData.shared.programme
        UpdatedDetails.shared.year = UserData.shared.year
        updatedUserInfo = false
        isValidEmail = false
        isValidPassword = false
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        guard let navBar = navigationController?.navigationBar else{return}
        if #available(iOS 11.0, *) {
            navBar.prefersLargeTitles = false
            
        }
    }
    
    func setupUI(){
        // Cancel Button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.layer.cornerRadius = 10;
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        cancelButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        // Submit Button
        saveButton.setTitle("Submit", for: .normal)
        saveButton.layer.cornerRadius = 10;
        saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        saveButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        saveButton.isEnabled = false
        
        // Table View
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        tableView.anchor(top: safeAreaLayoutGuide.topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, left: safeAreaLayoutGuide.leadingAnchor, right: safeAreaLayoutGuide.trailingAnchor)
    }
    
    func setupColors(){
        view.backgroundColor = selectedTheme.primaryColor
        cancelButton.backgroundColor = selectedTheme.secondaryPlaceholderColor
        saveButton.backgroundColor = selectedAccentColor.primaryColor
        saveButton.tintColor = selectedTheme.primaryColor
        cancelButton.tintColor = selectedTheme.primaryTextColor
        tableView.backgroundColor = selectedTheme.primaryColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return selectedTheme.statusBarStyle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    @objc func handleCancel(){
        UpdatedDetails.shared.name = nil
        UpdatedDetails.shared.username = nil
        UpdatedDetails.shared.email = nil
        UpdatedDetails.shared.department = nil
        UpdatedDetails.shared.programme = nil
        UpdatedDetails.shared.year = nil
        UpdatedDetails.shared.password = nil
        UpdatedDetails.shared.confirmedPassword = nil
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSave(){
        view.endEditing(true)
        let isValidName = (UpdatedDetails.shared.name?.count ?? 0 > 0 && UpdatedDetails.shared.name != UserData.shared.name)
        isValidEmail = (UpdatedDetails.shared.email?.count ?? 0 > 0 && UpdatedDetails.shared.email != UserData.shared.email)
        let isValidUsername = (UpdatedDetails.shared.username?.count ?? 0 > 0 && UpdatedDetails.shared.username != UserData.shared.username)
        let passwordLength = UpdatedDetails.shared.password?.count ?? 0
        isValidPassword = (passwordLength >= 6) && (passwordLength <= 16)
        let shouldUpdatePassword = (UpdatedDetails.shared.password == UpdatedDetails.shared.confirmedPassword)
        let updatedDepartmentInfo = (
            UserData.shared.department != UpdatedDetails.shared.department ||
            UserData.shared.programme != UpdatedDetails.shared.programme ||
            UserData.shared.year != UpdatedDetails.shared.year
        )
        
        if(shouldUpdatePassword && !isValidPassword){
            let action = UIAlertAction(title: "Ok", style: .cancel)
            let alertController = UIAlertController(title: "Invalid Password", message: "Password should be bewtween 6 and 16 characters", preferredStyle: .alert)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        UserData.shared.department = UpdatedDetails.shared.department
        UserData.shared.programme = UpdatedDetails.shared.programme
        UserData.shared.year = UpdatedDetails.shared.year
        
        if isValidName{
            UserData.shared.name = UpdatedDetails.shared.name
        }
        if isValidUsername{
            UserData.shared.username = UpdatedDetails.shared.username
        }
        
        updatedUserInfo = isValidName || isValidEmail || isValidUsername || updatedDepartmentInfo
        
        if(updatedUserInfo || isValidPassword){
            let reauthenticateVC = ReauthenticateViewController()
            reauthenticateVC.callback = reauthenticateCallback
            present(reauthenticateVC, animated: true)
        }
    }
    
    var updatedUserInfo = false
    var isValidEmail = false
    var isValidPassword = false
    
    func reauthenticateCallback(){
        let alert = UIAlertController(title: nil, message: "Updating Info...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(style: .gray)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        loadingIndicator.anchor(left: alert.view.leadingAnchor, paddingLeft: 20, height: 50, width: 50)
        loadingIndicator.centerY(alert.view.centerYAnchor)
        present(alert, animated: true, completion: nil)
        
        let dispatchGroup = DispatchGroup()
        if(updatedUserInfo){
            dispatchGroup.enter()
            APIService.updateUserInfo(){ success in
                if(success){
                    let name = Notification.Name(updateUserDataKey)
                    NotificationCenter.default.post(name: name, object: nil)
                }
                dispatchGroup.leave()
            }
        }
        
        if isValidEmail{
            dispatchGroup.enter()
            UserData.shared.email = UpdatedDetails.shared.email
            APIService.updateEmail(UserData.shared.email){ success in
                dispatchGroup.leave()
            }
        }
        if isValidPassword{
            dispatchGroup.enter()
            APIService.updatePassword(UpdatedDetails.shared.password){ success in
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else{return}
            self.dismiss(animated: true) {
                self.handleCancel()
            }
        }
    }
    
    deinit {
        print("Deinit")
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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

protocol EditDepartmentCallbackProtocol{
    func didFinishPicking(_ value: String, for department: DepartmentOptions)
}

extension EditProfileViewController: EditDepartmentCallbackProtocol{
    func didFinishPicking(_ value: String, for department: DepartmentOptions) {
        tableView.reloadData()
    }
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return EditDetailsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = UILabel()
        let view = UIView()
        view.addSubview(title)
        view.backgroundColor = selectedTheme.secondaryTextColor
        
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = selectedTheme.primaryColor
        title.text = EditDetailsSection(rawValue: section)?.description
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (EditDetailsSection(rawValue: section) == .ProfileImage) ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = EditDetailsSection(rawValue: section) else { return 0 }
        return section.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = EditDetailsSection(rawValue: indexPath.section) else {return UITableViewCell()}
        let cellDetails = section.cellDetails(for: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellDetails.cellType.reusableCellIdentifier, for: indexPath)
        
        switch cellDetails.cellType {
            case .textField:
                let textCell = cell as! EditDetailsTextCell
                textCell.selectionStyle = .none
                if(section == .Password){
                    textCell.type2 = PasswordOptions(rawValue: indexPath.row)
                    textCell.setup(placeholder: cellDetails.placeholder ?? "", isSecure: true, value: cellDetails.value)
                }
                else{
                    textCell.type1 = InfoOptions(rawValue: indexPath.row)
                    textCell.setup(placeholder: cellDetails.placeholder ?? "", isSecure: false, value: cellDetails.value)
                }
                
            case .image:
                let imageCell = cell as! EditDetailsImageCell
                imageCell.selectionStyle = .none
                imageCell.controller = self
                
            case .picker:
                let pickerCell = cell as! SettingsSelectorCell
                pickerCell.buttonLabel.text = cellDetails.placeholder
                pickerCell.selectedOptionLabel.text = cellDetails.value
            case .button: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = EditDetailsSection(rawValue: indexPath.section) else { return }
        let cellDetails = section.cellDetails(for: indexPath.row)
        switch cellDetails.cellType {
            case .picker: cellDetails.selectionHandler?()
            default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

enum EditDetailsCellType: Int, CaseIterable{
    case image
    case textField
    case picker
    case button
    
    var reusableCellIdentifier: String{
        switch self{
            case .textField:     return "EditProfileTextCellID"
            case .image:         return "EditProfileImageCellID"
            case .picker:        return "EditProfilePickerCellID"
            case .button:        return "EditProfileButtonCellID"
        }
    }
}

struct EditDetailsCell{
    var cellType: EditDetailsCellType
    var selectionHandler: (() -> Void)?
    var validationHandler: ((String) -> (Bool,String))?
    var placeholder: String?
    var value: String?
}

protocol EditDetailsCellProtocol{
    var cellDetails: EditDetailsCell {get}
}

enum EditDetailsSection: Int, CaseIterable, CustomStringConvertible {
    case ProfileImage
    case Info
    case Password
    case Department
//    case Interests

    var description: String {
        switch self {
            case .ProfileImage:   return ""
            case .Info:           return "User Info"
            case .Password:       return "Password"
            case .Department:   return "Department Details"
//            case .Interests:    return "Interests"
        }
    }
    
    var numberOfRows: Int{
        switch self {
            case .ProfileImage: return ProfileImageOptions.allCases.count
            case .Info:         return InfoOptions.allCases.count
            case .Password:     return PasswordOptions.allCases.count
            case .Department:   return DepartmentOptions.allCases.count
//            case .Interests:    return InterestsOptions.allCases.count
        }
    }
    
    func cellDetails(for index: Int) ->EditDetailsCell{
        switch self{
            case .ProfileImage:  return ProfileImageOptions(rawValue: index)!.cellDetails
            case .Info:         return InfoOptions(rawValue: index)!.cellDetails
            case .Password:     return PasswordOptions(rawValue: index)!.cellDetails
            case .Department:   return DepartmentOptions(rawValue: index)!.cellDetails
//            case .Interests:    return InterestsOptions(rawValue: index)!.cellDetails
        }
    }
}

enum ProfileImageOptions: Int, CaseIterable, EditDetailsCellProtocol{
    case profilePic
    var cellDetails: EditDetailsCell{
       return .init(cellType: .image)
    }
}

enum DepartmentOptions: Int, CaseIterable, EditDetailsCellProtocol{
    case programme
    case department
    case year
    
    var cellDetails: EditDetailsCell{
        switch self{
            case .programme:    return .init(cellType: .picker, selectionHandler: EditHandler.handleProgramme, placeholder: placeholder, value: value)
            case .department:   return .init(cellType: .picker, selectionHandler: EditHandler.handleDepartment, placeholder: placeholder, value: value)
            case .year:         return .init(cellType: .picker, selectionHandler: EditHandler.handleYear, placeholder: placeholder, value: value)
        }
    }
    
    var value: String?{
        switch self{
            case .programme:    return UpdatedDetails.shared.programme
            case .department:   return UpdatedDetails.shared.department
            case .year:         return UpdatedDetails.shared.year
        }
    }
    
    var placeholder: String?{
        switch self{
            case .programme:    return "Programme"
            case .department:   return "Department"
            case .year:         return "Year"
        }
    }
}

enum PasswordOptions: Int, CaseIterable, EditDetailsCellProtocol{
    case password
    case confirmPassword

    var cellDetails: EditDetailsCell{
        switch self{
        case .password:         return .init(cellType: .textField, selectionHandler: nil, validationHandler: EditHandler.validateUsername, placeholder: placeholder, value: value)
            
        case .confirmPassword:  return .init(cellType: .textField, selectionHandler: nil, validationHandler: EditHandler.validateUsername, placeholder: placeholder, value: value)
        }
    }
    
    var placeholder: String?{
        switch self{
            case .password:         return "Password"
            case .confirmPassword:  return "Conform Password"
        }
    }
    
    var value: String?{
        switch self{
            case .password:             return UpdatedDetails.shared.password
            case .confirmPassword:  return UpdatedDetails.shared.confirmedPassword
        }
    }
}

enum InfoOptions: Int, CaseIterable, EditDetailsCellProtocol{
    case name
    case email
    case username

    var cellDetails: EditDetailsCell {
        switch self {
            case .name:     return .init(cellType: .textField, selectionHandler: nil, validationHandler: EditHandler.validateUsername, placeholder: placeholder, value: value)
            case .email:    return .init(cellType: .textField, selectionHandler: nil, validationHandler: EditHandler.validateUsername, placeholder: placeholder, value: value)
            case .username: return .init(cellType: .textField, selectionHandler: nil, validationHandler: EditHandler.validateUsername, placeholder: placeholder, value: value)
        }
    }
    
    var placeholder: String?{
        switch self{
            case .name:      return "Name"
            case .email:     return "Email"
            case .username:  return "Username"
        }
    }
    
    var value: String?{
        switch self{
            case .name:      return UpdatedDetails.shared.name
            case .email:     return UpdatedDetails.shared.email
            case .username:  return UpdatedDetails.shared.username
        }
    }
}

class EditHandler{
    static var delegate: EditDepartmentCallbackProtocol?
    
    static func validateUsername(_ username: String?)->(Bool, String){
        return (true, "")
    }

    static func validateName(_ username: String?)->(Bool, String){
        return (true, "")
    }

    static func validateEmail(_ username: String?)->(Bool, String){
        return (true, "")
    }

    static func handleDepartment(){
        let vc = PickerViewController()
        vc.headerLabel.text = "Choose Department"
        vc.dataFor = .department
        vc.delegate = delegate
        vc.data = ["CSE", "ECE", "EEE", "BT", "MnC", "CE", "CST", "EP"]
        addPopup(viewController: vc)
    }
    
    static func handleProgramme(){
        let vc = PickerViewController()
        vc.headerLabel.text = "Choose Programme"
        vc.dataFor = .programme
        vc.delegate = delegate
        vc.data = ["BTech", "MTech", "Phd"]
        addPopup(viewController: vc)
    }
    
    static func handleYear(){
        let vc = PickerViewController()
        vc.headerLabel.text = "Choose Year"
        vc.dataFor = .year
        vc.delegate = delegate
        vc.data = ["2016-2020", "2017-2021", "2018-2022", "2019-2023"]
        addPopup(viewController: vc)
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

class PickerViewController: PopupViewController, UITableViewDelegate, UITableViewDataSource{
    private let cellID = "popupCellID"
    var data = [String]()
    let tableView = UITableView()
    var selectedData: String?
    var delegate: EditDepartmentCallbackProtocol?
    var dataFor: DepartmentOptions!
    
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
        height = 200
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: UITableViewCell!
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellID) {
            cell = dequeuedCell
        }
        else{
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 16)
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = selectedTheme.primaryTextColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateData(data[indexPath.row])
        delegate?.didFinishPicking(data[indexPath.row], for: dataFor)
        self.removeAnimate()
    }
    
    func updateData(_ value: String){
        switch dataFor{
            case .department:
                UpdatedDetails.shared.department = value
            case .programme:
                UpdatedDetails.shared.programme = value
            case .year:
                UpdatedDetails.shared.year = value
            case .none:
                break
        }
    }
}
