//
//  Interests.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 21/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit

class InterestViewController: UIViewController{
    let header = UILabel()
    let cellID = "InterestCellID"
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(InterestCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Interests"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupUI(){
        header.text = "Choose Atleast 5 Topic you are interested in"
        header.font = .systemFont(ofSize: 18, weight: .medium)
        header.textColor = selectedTheme.secondaryTextColor
        header.numberOfLines = 0
        
        view.backgroundColor = selectedTheme.primaryColor
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
    }
    
    func setupConstraints(){
        view.addSubview(header)
        view.addSubview(collectionView)
        let safeGuide = view.safeAreaLayoutGuide
        header.anchor(top: view.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingLeft: 10, paddingRight: 10, height: 50)
        collectionView.anchor(top: header.bottomAnchor, bottom: safeGuide.bottomAnchor, left: safeGuide.leadingAnchor, right: safeGuide.trailingAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
                layout.invalidateLayout()
            }
        })
    }
}

extension InterestViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allowedTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        if let interestCell = cell as? InterestCell{
            interestCell.textLabel.text = allowedTags[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGFloat
        if UIApplication.shared.statusBarOrientation.isLandscape{
            let width = view.safeAreaLayoutGuide.layoutFrame.width
            size = (width - 40)/CGFloat(3)
        }
        else{
            let width = view.safeAreaLayoutGuide.layoutFrame.width
            size = (width - 30)/CGFloat(2)
        }
        return CGSize(width: size, height: size)
    }
}

class InterestCell: UICollectionViewCell{
    let image = UIImageView()
    let textLabel = UILabel()
    let tickMark = UIImageView()
    let overlay = UIView()
    
    override var isSelected: Bool{
        didSet{
            if(self.isSelected){
                tickMark.isHidden = false
                image.layer.borderWidth = 5
                overlay.backgroundColor = .init(white: 0, alpha: 0.6)
            }
            else{
                tickMark.isHidden = true
                image.layer.borderWidth = 0
                overlay.backgroundColor = .init(white: 0, alpha: 0.45)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        image.backgroundColor = .clear
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.image = UIImage(named: "CodingClub2")
        image.layer.borderColor = selectedAccentColor.primaryColor.cgColor
        overlay.backgroundColor = .init(white: 0, alpha: 0.45)
        image.addSubview(overlay)
        overlay.fillSuperView()
        
        textLabel.textColor = .white
        textLabel.font = .systemFont(ofSize: 18, weight: .bold)
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        
        let size = CGSize(width: 35, height: 35)
        tickMark.image = UIImage(named: "TickMark")?.resizeImage(size: size).withRenderingMode(.alwaysTemplate)
        tickMark.tintColor = selectedAccentColor.primaryColor
        tickMark.isHidden = true
        
        addSubview(image)
        addSubview(textLabel)
        addSubview(tickMark)
        
        image.fillSuperView()
        textLabel.anchor(left: image.leadingAnchor, right: image.trailingAnchor, paddingLeft: 20, paddingRight: 20)
        textLabel.centerY(image.centerYAnchor)
        tickMark.anchor(top: image.topAnchor, right: image.trailingAnchor, paddingTop: 10, paddingRight: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
