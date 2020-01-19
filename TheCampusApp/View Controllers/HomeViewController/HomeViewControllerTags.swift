//
//  HomeViewControllerTags.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 18/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellID, for: indexPath)
        
        if let tagCell = cell as? TagCell{
            tagCell.tagLabel.text = tags[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = tags[indexPath.item].size(withAttributes: [.font : UIFont.systemFont(ofSize: 14)
        ])
        size.width += 20
        size.height += 15
        return size
    }
}

class TagCell: UICollectionViewCell{
    let tagLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupColors()
    }
    
    func setupUI(){
        tagLabel.layer.cornerRadius = 10
        tagLabel.clipsToBounds = true
        tagLabel.font = .systemFont(ofSize: 14)
        tagLabel.textAlignment = .center
    }
    
    func setupColors(){
        tagLabel.textColor = selectedTheme.primaryTextColor
        tagLabel.backgroundColor = selectedTheme.secondaryPlaceholderColor.withAlphaComponent(0.3)
    }
    
    func setupConstraints(){
        addSubview(tagLabel)
        tagLabel.fillSuperView()
        let heightConstraint = tagLabel.heightAnchor.constraint(equalToConstant: 20)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
