//
//  CustomToolBar.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 29/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

class ToolBarButton: UIButton{
    init(imageName: String) {
        super.init(frame: .zero)
        let size = CGSize(width: 30, height: 30)
        let image = UIImage(named: imageName)?.resizeImage(size: size).withRenderingMode(.alwaysTemplate)
        self.setImage(image, for: .normal)
        tintColor = unselectedColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol CustomToolBarDelegate{
    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide(notification: NSNotification)
}

extension CustomToolBarDelegate{
    func keyboardWillShow(notification: NSNotification){}
    func keyboardWillHide(notification: NSNotification){}
}

class CustomToolBar: UIView{
    var leftItems = [UIButton]()
    var rightItems = [UIButton]()
    var edgeInsets: UIEdgeInsets?
    var toolSpacing: CGFloat?
    var bottomConstraint: NSLayoutConstraint!
    
    var topBorder : UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
//    override func didMoveToWindow() {
//        super.didMoveToWindow()
//        if #available(iOS 11.0, *) {
//            if let window = self.window {
//                self.translatesAutoresizingMaskIntoConstraints = false
//                self.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
//            }
//        }
//    }

    init(height: CGFloat, controller: UIViewController){
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        self.backgroundColor = .white
        controller.view.addSubview(self)
        if #available(iOS 11.0, *) {
            let layoutGuide = controller.view.safeAreaLayoutGuide
            self.anchor(left: layoutGuide.leadingAnchor, right: layoutGuide.trailingAnchor)
//            bottomConstraint = self.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: 0)
        } else {
            self.anchor(left: controller.view.leadingAnchor, right: controller.view.trailingAnchor)
        }
        bottomConstraint = self.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor, constant: 0)
        bottomConstraint.isActive = true
    }
    
    func layout(){
        // Layout Left Items
        var leftConstraint = self.leadingAnchor
        var leftSpacing = self.edgeInsets?.left
        for tool in leftItems{
            addSubview(tool)
            tool.anchor(top: topAnchor, bottom: bottomAnchor, left: leftConstraint, paddingTop: edgeInsets?.top, paddingBottom: edgeInsets?.bottom, paddingLeft: leftSpacing)
            leftConstraint = tool.trailingAnchor
            leftSpacing = toolSpacing
        }
        
        // Layout Right Items
        var rightConstraint = self.trailingAnchor
        var rightSpacing = self.edgeInsets?.right
        for tool in rightItems{
            addSubview(tool)
            tool.anchor(top: topAnchor, bottom: bottomAnchor, right: rightConstraint, paddingTop: edgeInsets?.top, paddingBottom: edgeInsets?.bottom, paddingRight: rightSpacing)
            rightConstraint = tool.leadingAnchor
            rightSpacing = toolSpacing
        }
        
        // Top Border
        addSubview(topBorder)
        topBorder.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ExtraTextOptionsButton: UIButton{
    init(text: String, imageName: String) {
        super.init(frame: .zero)
        let size = CGSize(width: 30, height: 30)
        let image = UIImage(named: imageName)?.resizeImage(size: size).withRenderingMode(.alwaysTemplate)
        self.setImage(image, for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .left
        self.setTitle(text, for: .normal)
        self.setColor(unselectedColor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(_ color: UIColor){
        self.tintColor = color
        self.setTitleColor(color, for: .normal)
    }
}

class ExtraTextOptionsView: UIView{
    let unOrderedListButton : ExtraTextOptionsButton = {
        let button = ExtraTextOptionsButton(text: "Unordered List", imageName: "UnorderedList")
        return button
    }()
    
    let orderedListButton : ExtraTextOptionsButton = {
        let button = ExtraTextOptionsButton(text: "Ordered List", imageName: "UnorderedList")
        return button
    }()
    
    let quoteButton : ExtraTextOptionsButton = {
        let button = ExtraTextOptionsButton(text: "Quote", imageName: "Quote")
        return button
    }()
    
    let codeButton : ExtraTextOptionsButton = {
        let button = ExtraTextOptionsButton(text: "Code", imageName: "CurlyBraces")
        return button
    }()
    
    let mathButton : ExtraTextOptionsButton = {
        let button = ExtraTextOptionsButton(text: "Math", imageName: "Sigma")
        return button
    }()
    
    let background = UIView()
    
    
    init(padding: CGFloat){
        super.init(frame: .zero)
        
        let stack = UIStackView(arrangedSubviews: [unOrderedListButton, orderedListButton, quoteButton, codeButton, mathButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        addSubview(background)
        background.addSubview(stack)
        backgroundColor = .white

        for item in stack.arrangedSubviews{
            item.anchor(left: stack.leadingAnchor, right: stack.trailingAnchor, paddingLeft: 0, paddingRight: 0)
        }
        
        background.backgroundColor = UIColor(white: 0.83, alpha: 1)
        
        // Constraints
        stack.anchor(top: background.topAnchor, bottom: background.bottomAnchor, left: background.leadingAnchor, right: background.trailingAnchor)
        background.anchor(top: topAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: padding, paddingBottom: padding, paddingLeft: padding, paddingRight: padding)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if let window = self.window {
                self.translatesAutoresizingMaskIntoConstraints = false
                self.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
//                self.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

