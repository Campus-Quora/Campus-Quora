//
//  PopupBaseClass.swift
//  Music App
//
//  Created by Yogesh Kumar on 29/04/19.
//  Copyright © 2019 Yogesh Kumar. All rights reserved.
//

import UIKit

protocol BasePopupDelegate{
    func numberOfItems()->Int
    func cellForItem(at indexPath: IndexPath)->UICollectionViewCell
    func didSelectRow(at index: Int)
    func sizeOfCell()->CGSize
}

let headerHeight: CGFloat = 80
let spacing: CGFloat = 20
let elementHeight: CGFloat = 40
let numberInOneRow: Int = 5

class BasePopup: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let header = UILabel()
    var cellID: String!
    var delegate: BasePopupDelegate?
    
    init(frame: CGRect, headerText: String){
        super.init(frame: frame)
        backgroundColor = selectedTheme.secondColor
        header.text = headerText
        header.font = UIFont(name: "Avenir-Heavy", size: 24)
        header.textColor = selectedTheme.textColor
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setUpHeader()
        setUpCollectionView()
    }
    
    func setUpHeader(){
        header.translatesAutoresizingMaskIntoConstraints = false
        addSubview(header)
        
        NSLayoutConstraint.activate([
            header.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            header.topAnchor.constraint(equalTo: self.topAnchor, constant: spacing),
            header.heightAnchor.constraint(equalToConstant: headerHeight - 2*spacing),
            ])
    }
    
    func setUpCollectionView(){
        collectionView.backgroundColor = .clear
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            collectionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: spacing),
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate!.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return delegate!.cellForItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return delegate!.sizeOfCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate!.didSelectRow(at: indexPath.item)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
