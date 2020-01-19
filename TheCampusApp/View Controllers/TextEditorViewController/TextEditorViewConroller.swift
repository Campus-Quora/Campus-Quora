//
//  AnswerViewConroller.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 12/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit

// MARK:- Placeholder UITextView
class PlaceholderTextView: UITextView{
    var placeholderLabel = UILabel()
    var attributedPlaceholder: NSAttributedString?{
        didSet{
            placeholderLabel.attributedText = attributedPlaceholder
            placeholderLabel.numberOfLines = 0
            placeholderLabel.lineBreakMode = .byWordWrapping
        }
    }
    
    func setupPlaceholderConstraints(_ view: UIView){
        self.addSubview(placeholderLabel)
        placeholderLabel.anchor(top: self.topAnchor, left: self.leadingAnchor, right: view.trailingAnchor, paddingTop: 8, paddingLeft: 5, paddingRight: 5)
    }
}

class TextEditorViewController: ColorThemeObservingViewController{
    var selectedColor = selectedAccentColor.primaryColor
    var unselectedColor = selectedTheme.primaryTextColor
    
    // MARK:- Constraint Variabless
    lazy var leftOffset: CGFloat = {
        let offset: CGFloat = 2 * ((toolbar.toolSpacing ?? 0) + 30) - 20
        return offset
    }()
    lazy var toolbarHideConstraint = toolbar.heightAnchor.constraint(equalToConstant: 0)
    var textOptionsViewRightConstraintExpanded: NSLayoutConstraint! = nil
    var textOptionsViewRightConstraintCollapsed: NSLayoutConstraint! = nil
    
    // MARK:- UI Elements
    let toolbar = CustomToolBar()
    let doneButton = UIButton()
    let addImageButton = ToolBarButton(imageName: "AddImage")
    let addLinkButton = ToolBarButton(imageName: "Link")
    let textOptionsButton = ToolBarButton(imageName: "Paragraph")
    let textOptionsView = TextFormatOptionsView()
     
//    var textViews = [PlaceholderTextView]()
    var selectedTextView: PlaceholderTextView?
    var placeholderText = [NSAttributedString]()
    var isRichTextEditable = [Bool]()
    var textOptionsHidden = true
    
    lazy var imagePickerVC: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        return picker
    }()


    // MARK:- Overriden Members
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
//    override var inputAccessoryView: UIView?{
//        return self.toolbar
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupThemeColors()
        setupAccentColors()
        
        imagePickerVC.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.1) {
            self.toolbar.alpha = 0
        }
    }
    
    func setupUI(){
        // Toolbar
        toolbar.autoresizingMask = .flexibleHeight
        toolbar.toolSpacing = 20
        toolbar.edgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 7)
        toolbar.leftItems = [addImageButton, addLinkButton, textOptionsButton]
        toolbar.rightItems = [doneButton]
        toolbar.layout()
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.tintColor = .white
        doneButton.layer.cornerRadius = 5;
        doneButton.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        doneButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        addImageButton.tag = 0
        addImageButton.addTarget(self, action: #selector(handleButtonColor), for: .touchUpInside)
        addImageButton.addTarget(self, action: #selector(handleImageSelection), for: .touchUpInside)

        addLinkButton.tag = 1
        addLinkButton.addTarget(self, action: #selector(handleButtonColor), for: .touchUpInside)
        
        textOptionsButton.tag = 2
        textOptionsButton.addTarget(self, action: #selector(handleButtonColor), for: .touchUpInside)
        textOptionsButton.addTarget(self, action: #selector(handleTextOptions), for: .touchUpInside)
        
        textOptionsView.backgroundColor = .clear
        textOptionsView.initialise(self.unselectedColor)
        textOptionsView.alpha = 0
        textOptionsView.isUserInteractionEnabled = false
    }
    
    func setupConstraints(){
        toolbar.insertSubview(textOptionsView, belowSubview: doneButton)
        
        // textOptionsView
        textOptionsView.anchor(top: toolbar.backgroundView.topAnchor, bottom: toolbar.bottomAnchor, left: toolbar.leftItems.last!.trailingAnchor, right: doneButton.leadingAnchor, paddingTop: 7, paddingBottom: 7, paddingLeft: 10, paddingRight: 10)
    }
    
    func setupThemeColors(){
        toolbar.backgroundView.backgroundColor = selectedTheme.toolbarColor
        unselectedColor = selectedTheme.primaryTextColor
        addImageButton.tintColor = unselectedColor
        addLinkButton.tintColor = unselectedColor
        textOptionsButton.tintColor = unselectedColor
        textOptionsView.setupColors(unselectedColor)
    }
    
    func setupAccentColors(){
        selectedColor = selectedAccentColor.primaryColor
        doneButton.backgroundColor = selectedAccentColor.primaryColor
    }
}
