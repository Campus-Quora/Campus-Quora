//
//  PopupViewController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 13/10/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

protocol PopupDelegate{
    var dismissView: UIView{get set}
    var popupView: UIView{get set}
    var height: CGFloat{get set}
}

class PopupViewController: UIViewController, PopupDelegate{
    // MARK:- Constants
    var height: CGFloat = 50
    
    // MARK:- UI Elements
    var dismissView = UIView()
    var popupView = UIView()
    let headerView = UIView()
    let headerLabel = UILabel()
    
    // MARK:- Setup Methods
    func setupColors(){
        headerView.backgroundColor = selectedAccentColor.primaryColor
    }
    
    func setupView(){
        // Header Label
        headerLabel.textColor = .white
        headerLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        // Popup View
        popupView.layer.backgroundColor = UIColor.clear.cgColor
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        popupView.layer.shadowOpacity = 0.3
        popupView.layer.shadowRadius = 4.0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *){
            headerView.clipsToBounds = false
            headerView.layer.cornerRadius = 20
            headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.bounds = headerView.frame
            rectShape.position = headerView.center
            rectShape.path = UIBezierPath(roundedRect: headerView.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 40, height: 40)).cgPath
            headerView.layer.mask = rectShape
        }
    }
    
    func setupContraints(){
        // Popup View
        view.addSubview(popupView)
        popupView.anchor(bottom: view.layoutMarginsGuide.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingLeft: 10, paddingRight: 10, height: self.height)
        
        // HeaderView
        popupView.addSubview(headerView)
        headerView.anchor(top: popupView.topAnchor, left: popupView.leadingAnchor, right: popupView.trailingAnchor, height: 50)
        
        // Header Label
        headerView.addSubview(headerLabel)
        headerLabel.centerX(headerView.centerXAnchor)
        headerLabel.centerY(headerView.centerYAnchor)
    }
    
    func setupDismissView(){
        dismissView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        dismissView.alpha = 0.5
        view.addSubview(dismissView)
        dismissView.fillSuperView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ThemePopUpViewController.removeAnimate))
        tap.cancelsTouchesInView = false
        dismissView.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDismissView()
        setupView()
        setupContraints()
        setupColors()
    }
    
    
    @objc func removeAnimate(){
        let dy : CGFloat = self.height + 50
        let finalFrame = self.popupView.frame.offsetBy(dx: 0, dy: dy)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.popupView.frame = finalFrame
            self.popupView.alpha = 0
            self.dismissView.alpha = 0
        }) { (finished) in
            if(finished){
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        }
    }
}

