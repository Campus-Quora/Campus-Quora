//
//  ProfileViewController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 27/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

//visibleHeight = UIScreen.main.nativeBounds.height/UIScreen.main.nativeScale - navigationController!.navigationBar.frame.size.height - tabBarController!.tabBar.frame.size.height - UIApplication.shared.statusBarFrame.height

import UIKit

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    let headerID = "headerID"
    let cellID = "cellID"
    var headerHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // This is used to force collectionView to stick to safe layout (useful in landscape)
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }
        
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: cellID)
        
        headerHeight = (UIScreen.main.nativeBounds.height/UIScreen.main.nativeScale) * 0.2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width = collectionView.frame.width
        return CGSize(width: width, height: headerHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath)
        return header
    }
    
    func setupNavigationBar(){
        navigationItem.title = "Profile"
        guard let navBar = navigationController?.navigationBar else {return}
        if #available(iOS 11.0, *) {
            navBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
        }
//        let image = UIImage().with(color: .white)
//        navBar.setBackgroundImage(image, for: .default)
        navBar.shadowImage = UIImage()
        navBar.tintColor = primaryColor
        navBar.isTranslucent = false
    }
    
    func setupUI(){
        collectionView.backgroundColor = .white
        setupBottomLine()
    }
    
    func setupBottomLine(){
        let bottomLine = UIView()
        bottomLine.backgroundColor = .gray
        collectionView.addSubview(bottomLine)
        bottomLine.anchor(left: collectionView.leadingAnchor, right: collectionView.trailingAnchor, height: 1)
        bottomLine.widthAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 1).isActive = true
    }
    
    
}

extension ProfileViewController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        if let cell = cell as? PostCell{
            
        }
        
        return cell
    }
}
