//
//  EventHandlers.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 05/10/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

// MARK:- PostViewController Extension #1
// Event Handlers
extension PostViewController{
    @objc func handleDone(){
        view.endEditing(true)
    }
    
    @objc func handleAsk(){
        print("Asking")
    }
    
    @objc func handleButtonColor(_ sender: UIButton){
        sender.tintColor = selectedColor
        for button in toolbar.leftItems{
            if button.tag != sender.tag{
                button.tintColor = unselectedColor
            }
        }
    }
    
    @objc func handleTextOptions(){
        if(toolbar.leadingConstraint.constant == 10){
            // Expand
            self.toolbar.leadingConstraint.constant = -leftOffset
            textOptionsViewRightConstraintCollapsed.isActive = false
            textOptionsViewRightConstraintExpanded.isActive = true
        }
        else{
            // Collapse
            self.toolbar.leadingConstraint.constant = 10
            textOptionsViewRightConstraintCollapsed.isActive = true
            textOptionsViewRightConstraintExpanded.isActive = false
            textOptionsButton.tintColor = unselectedColor
        }
        
        UIView.animate(withDuration: 0.25){
            self.toolbar.superview?.layoutIfNeeded()
        }
        
    }
}


class CustomVC: UIViewController{
    override func viewDidLoad(){
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(resign), for: .touchUpInside)
        view.addSubview(button)
        button.anchor(top: view.topAnchor, left: view.leadingAnchor, paddingTop: 400, paddingLeft: 200)
    }
    
    @objc func resign(){
        navigationController?.popViewController(animated: true)
    }
}
