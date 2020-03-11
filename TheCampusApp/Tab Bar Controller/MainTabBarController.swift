//
//  MainTabBarController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 27/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LoginViewController())
                navController.modalPresentationStyle = .overCurrentContext
                self.present(navController, animated: true, completion: nil)
            }
        }
        else{
            APIService.getUserInfo()
            setupViewControllers()
        }
        
        // Add Notification Observer
        var name = Notification.Name(changeThemeKey)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeTheme), name: name, object: nil)
        
        name = Notification.Name(changeAccentColorKey)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeAccentColor), name: name, object: nil)
    }
    
    func setupViewControllers(){
        // List Of Component View Controlllers
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let postVC = UINavigationController(rootViewController: PostViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        viewControllers = [homeVC, postVC, profileVC]
        
        // MARK:- Setting Image for tabBarItem
        let imageNames = ["Home", "Plus", "Profile"]
        let imageSize = CGSize(width: 30, height: 30)
        var image: UIImage!
        var i: Int = 0
        
        for vc in viewControllers!{
            image = UIImage(named: imageNames[i])?.resizeImage(size: imageSize)
            vc.tabBarItem = UITabBarItem(title: nil, image: image, tag: i)
            i += 1
        }
        
        // MARK:- Customisizing Tab Bar
        guard let tabBarItems = tabBar.items else{return}
        setupColors()
        
        for item in tabBarItems{
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
        tabBar.shadowImage = UIImage()
        tabBar.isTranslucent = false
    }
    
    func setupColors(){
        tabBar.barTintColor = selectedTheme.primaryColor
        tabBar.tintColor = selectedAccentColor.primaryColor
        guard let tabBarItems = tabBar.items else{return}
        if #available(iOS 10.0, *) {
            tabBar.unselectedItemTintColor = selectedTheme.unselectedTabBarItemColor
        }
        else{
            for item in tabBarItems {
                item.image = item.selectedImage!.with(color: selectedTheme.unselectedTabBarItemColor).withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    override func updateColors() {
        setupColors()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if(viewController.tabBarItem.tag == 1){
            let postVC = UINavigationController(rootViewController: PostViewController())
            present(postVC, animated: true, completion: nil)
            return false
        }
        return true
    }
}

// MARK:- Extension #1
extension MainTabBarController: UITabBarControllerDelegate {
    // Tab Transition
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabTransition(duration: 0.3)
    }
}

// This class is for transition animation
class TabTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var transitionDuration: Double!
    
    init(duration: Double) {
        self.transitionDuration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else {
                transitionContext.completeTransition(false)
                return
            }
        
        let toFrameEnd = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = toFrameEnd
        
        if(toVC.tabBarItem.tag > fromVC.tabBarItem.tag){
            fromFrameEnd.origin.x = toFrameEnd.origin.x - toFrameEnd.width
            toVC.view.frame.origin.x = toFrameEnd.origin.x + toFrameEnd.width
        }
        else{
            fromFrameEnd.origin.x = toFrameEnd.origin.x + toFrameEnd.width
            toVC.view.frame.origin.x = toFrameEnd.origin.x - toFrameEnd.width
        }
        
        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toVC.view)
            UIView.animate(withDuration: self.transitionDuration, animations: {
                fromVC.view.frame = fromFrameEnd
                toVC.view.frame = toFrameEnd
            }, completion: {success in
                fromVC.view.removeFromSuperview()
                transitionContext.completeTransition(success)
            })
        }
    }
}
