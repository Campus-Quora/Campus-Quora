//
//  TagStripView.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 19/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit

class TagStripView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let tagCellID = "tagCellID"
    var data = [String]()
    
    init(){
        super.init(frame: .zero)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: tagCellID)
        backgroundColor = selectedTheme.primaryColor
        collectionView.backgroundColor = selectedTheme.primaryColor
        addSubview(collectionView)
        collectionView.fillSuperView()
        heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellID, for: indexPath)
        if let tagCell = cell as? TagCell{
            tagCell.tagLabel.text = data[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = data[indexPath.item]
        var size = tag.size(withAttributes: [.font : UIFont.systemFont(ofSize: 14)])
        size.width += 20
        size.height += 15
        return size
    }
}
