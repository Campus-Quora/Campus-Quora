//
//  PostViewController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 27/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

class PostViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }
    
    func setupNavigationBar(){
        navigationItem.title = "Post"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupUI(){
        view.backgroundColor = .white
    }
}
