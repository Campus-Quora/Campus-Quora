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
    let selectedColor = UIColor.white
    let unselectedColor = UIColor.black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navigationController = UINavigationController(rootViewController: LoginViewController())
                self.present(navigationController, animated: true, completion: nil)
            }
            return
        }
        
        setupViewControllers()
    }
    
    func setupViewControllers(){
        // List Of Component View Controlllers
        let homeVC = HomeViewController()
        let postVC = PostViewController()
        let profileVC = ProfileViewController()
        viewControllers = [homeVC, postVC, profileVC]
        
        // MARK:- Setting Image for tabBarItem
        let imageNames = []
        let imageSize = CGSize(width: 30, height: 30)
        var image: UIImage!
        var i: Int = 0
        
        for vc in viewControllers!{
            image = UIImage(named: imageNames[i])?.resizeImage(size: imageSize)
            vc.tabBarItem.selectedImage = image
            vc.tabBarItem.tag = i
            i += 1
        }
        
        // MARK:- Customisizing Tab Bar
        // Color of selected tab
        tabBar.tintColor = selectedColor
        
        // Color of unselected tab
        if #available(iOS 10.0, *) {
            tabBar.unselectedItemTintColor = unselectedColor
        }
        else{
            for item in self.tabBar.items! {
                item.image = item.selectedImage!.with(color: unselectedColor).withRenderingMode(.alwaysOriginal)
            }
        }
        
        // Transparent Tab Bar
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
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

