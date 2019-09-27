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
    var headerHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        
        headerHeight = (UIScreen.main.nativeBounds.height/UIScreen.main.nativeScale) * 0.2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.invalidateLayout()
        }
        
        if UIDevice.current.orientation.isLandscape{
        
        }else{
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        // Set Height
        var height = headerHeight
        if UIDevice.current.orientation.isLandscape{
            height = height * 0.8
        }
        
        // Set width
        let width = collectionView.frame.width

        return CGSize(width: width, height: height)
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
        }
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
    }
    
    func setupUI(){
        collectionView.backgroundColor = .white
    }
}
