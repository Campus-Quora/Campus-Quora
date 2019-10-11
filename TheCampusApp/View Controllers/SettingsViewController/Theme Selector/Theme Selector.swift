//
//  Popup.swift
//  Music App
//
//  Created by Yogesh Kumar on 27/04/19.
//  Copyright © 2019 Yogesh Kumar. All rights reserved.
//

import UIKit

class OptionSelector: BasePopup, BasePopupDelegate{
    var items = [String]()
    var selectedOption: String!
    var function: (Int,String)->Void = {_,_ in }
    
    init(headerText: String, itemsToDisplay: [String], selectedOption: String, function: @escaping (Int,String)->Void) {
        
        // Setting up Frame
        let height = headerHeight + CGFloat(itemsToDisplay.count)*elementHeight + CGFloat(itemsToDisplay.count)*spacing
        let width = UIScreen.main.bounds.width - 40
        let window = UIApplication.shared.delegate?.window
        let origin = CGPoint(x: (window!!.frame.width - width)/2, y: (window!!.frame.height - height)/2)
        let frame = CGRect(origin: origin, size: CGSize(width: width, height: height))
        
        super.init(frame: frame, headerText: headerText)
        
        self.items = itemsToDisplay
        self.selectedOption = selectedOption
        self.function = function
        delegate = self
        cellID = "PopupCellID"
        
        header.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: optionOffsetFromLeft - spacing).isActive = true
        collectionView.register(OptionSelectorCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -spacing).isActive = true
        
        let name = Notification.Name(dismissPopupKey)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPopup), name: name, object: nil)
    }
    
    @objc func dismissPopup(){
        NotificationCenter.default.removeObserver(self)
        self.removeFromSuperview()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        if let cell = cell as? OptionSelectorCell{
            
            cell.setupCell(data: items[indexPath.item], selected : items[indexPath.item] == selectedOption)
        }
        return cell
    }
    
    func didSelectRow(at index: Int) {
        function(index,selectedOption)
    }
    
    func sizeOfCell() -> CGSize {
        let width = collectionView.frame.width
        let height = elementHeight
        return CGSize(width: width, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
