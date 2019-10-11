//
//  Accent Color.swift
//  Music App
//
//  Created by Yogesh Kumar on 29/04/19.
//  Copyright © 2019 Yogesh Kumar. All rights reserved.
//

import UIKit

class AccentColorPicker: BasePopup, BasePopupDelegate{
    
    var selectedOption: UIColor!
    let footer = UIView()
    let footerHeight: CGFloat = 80
    var function: (Bool)->Void = {_ in }
    
    init(headerText: String,function: @escaping (Bool)->Void) {
        // Create Frame
        let height = headerHeight + footerHeight +  CGFloat(Int(accentColors.count/numberInOneRow))*colorCellSize + CGFloat(accentColors.count)*spacing
        let width = colorCellSize*CGFloat(numberInOneRow) + spacing*CGFloat(numberInOneRow + 1)
        let window = UIApplication.shared.delegate?.window
        let origin = CGPoint(x: (window!!.frame.width - width)/2, y: (window!!.frame.height - height)/2)
        let frame = CGRect(origin: origin, size: CGSize(width: width, height: height))
        
        super.init(frame: frame, headerText: headerText) 
        delegate = self
        self.selectedOption = selectedAccentColor.primaryColor
        self.function = function
        cellID = "AccentColorCellID"
        
        header.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing).isActive = true
        
        setUpFooter()
        collectionView.register(AccentColorPickerCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -spacing).isActive = true
        let name = Notification.Name(dismissPopupKey)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPopup), name: name, object: nil)
    }
    
    func setUpFooter(){
        footer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(footer)
        NSLayoutConstraint.activate([
            footer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            footer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            footer.heightAnchor.constraint(equalToConstant: footerHeight - 2*spacing),
            footer.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc func dismissPopup(){
        NotificationCenter.default.removeObserver(self)
        self.removeFromSuperview()
    }
    
    func numberOfItems() -> Int {
        return accentColors.count
    }
    
    func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        if let cell = cell as? AccentColorPickerCell{
            
//            cell.setupCell(data: accentColors[indexPath.item], selected : accentColors[indexPath.item] == selectedOption)
        }
        return cell
    }
    
    func didSelectRow(at index: Int) {
//        if(selectedOption != accentColors[index]){
//            selectedAccentColor = accentColors[index]
//            function(true)
//        }
//        else{
//            function(false)
//        }
    }
    
    func sizeOfCell() -> CGSize {
        return CGSize(width: colorCellSize, height: colorCellSize)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
