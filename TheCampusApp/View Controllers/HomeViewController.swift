//
//  HomeViewController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 27/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import Down
import Firebase

class HomeViewController: UIViewController, UITextViewDelegate{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupColors()
    }
    
    func setupNavigationBar(){
        navigationItem.title = "Home"
        guard let navBar = navigationController?.navigationBar else{ return }
        if #available(iOS 11.0, *) {
            navBar.prefersLargeTitles = true
        }
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.tintColor = selectedTheme.primaryColor
    }
    
    func setupUI(){
        
    }
    
    func setupColors(){
        view.backgroundColor = selectedTheme.primaryColor
        navigationController?.navigationBar.tintColor = selectedTheme.primaryColor
    }
}


//        editor = Notepad(frame: view.bounds, themeFile: "one-light")
//        editor?.autocorrectionType = .no
//        editor?.autocapitalizationType = .none
//        view.addSubview(editor!)
//        editor?.textContainerInset = UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20)
//        editor?.delegate = self

//
//        view.addSubview(renderedView)
//        renderedView.textContainerInset = UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20)
//        renderedView.font = .systemFont(ofSize: 16)
////        renderedView.isEditable = false
//        renderedView.anchor(top: view.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 100, height: 300)
//        renderedView.layer.borderWidth = 1
//        renderedView.layer.borderColor = UIColor.gray.cgColor

//        let toolbar = TextFormatOptionsView()
//        toolbar.dataSource = renderedView
//        toolbar.initialise()
//        toolbar.backgroundColor = .yellow
//        view.addSubview(toolbar)
//        toolbar.anchor(bottom: view.layoutMarginsGuide.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingBottom: 80, height: 50)

//    func textViewDidChange(_ textView: UITextView) {
//        let attrText = try? Down(markdownString: editor!.text).toAttributedString()
//        renderedView.attributedText = attrText
//    }

