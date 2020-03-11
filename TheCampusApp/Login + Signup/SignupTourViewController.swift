//
//  SignupTourViewController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 22/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit

class SignupTourViewController: UIViewController, UIPageViewControllerDelegate{
    let pageControl = UIPageControl()
    let nextButton = UIButton()
    let prevButton = UIButton()
    let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    lazy var stack = UIStackView(arrangedSubviews: [prevButton, pageControl, nextButton])
    
    let detailsVC = UINavigationController(rootViewController: SignUpDetailsViewController())
    let interestVC = UINavigationController(rootViewController: InterestViewController())
    let welcomeVC = UINavigationController(rootViewController: WelcomeViewController())
    lazy var pages = [detailsVC, interestVC, welcomeVC]
    
    override func viewDidLoad(){
        setupUI()
        super.viewDidLoad()
        EditHandler.rootViewController = self
        pageVC.delegate = self
        pageVC.setViewControllers([pages[0]], direction: .reverse, animated: true, completion: nil)
    }
    
    func setupUI(){
        view.backgroundColor = selectedTheme.primaryColor
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(selectedAccentColor.primaryColor, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        
        prevButton.setTitle("Prev", for: .normal)
        prevButton.setTitleColor(selectedTheme.secondaryTextColor, for: .normal)
        prevButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        prevButton.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = selectedTheme.secondaryPlaceholderColor.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = selectedAccentColor.primaryColor
        
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        stack.alignment = .center
        
        for i in 0 ..< pages.count{
            pages[i].view.tag = i
        }
                
        view.addSubview(stack)
        self.addChild(pageVC)
        pageVC.willMove(toParent: self)
        view.addSubview(pageVC.view)

        let safeLayout = view.safeAreaLayoutGuide
        pageVC.view.anchor(top: view.topAnchor, bottom: stack.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor)
        stack.anchor(bottom: safeLayout.bottomAnchor, left: safeLayout.leadingAnchor, right: safeLayout.trailingAnchor, paddingLeft: 20, paddingRight: 20, height: 40)
    }
    
    @objc func handleNext(){
        if(pageControl.currentPage <= pageControl.numberOfPages - 2){
            pageControl.currentPage += 1
            pageVC.setViewControllers([pages[pageControl.currentPage]], direction: .forward, animated: true, completion: nil)
        }
        else{
            finalSetup()
        }
        prevButton.setTitleColor(selectedAccentColor.primaryColor, for: .normal)
    }
    
    @objc func handlePrev(){
        if(pageControl.currentPage != 0){
            pageControl.currentPage -= 1
            pageVC.setViewControllers([pages[pageControl.currentPage]], direction: .reverse, animated: true, completion: nil)
        }
        if(pageControl.currentPage == 0){
            prevButton.setTitleColor(selectedTheme.secondaryTextColor, for: .normal)
        }
    }
    
    func finalSetup(){
        UserData.shared.department = UpdatedDetails.shared.department
        UserData.shared.programme = UpdatedDetails.shared.programme
        UserData.shared.year = UpdatedDetails.shared.year
        
        if let vc = interestVC.viewControllers[0] as? InterestViewController{
            let indexPaths = vc.collectionView.indexPathsForSelectedItems
            var tags = [String]()
            indexPaths?.forEach({ (indexPath) in
                tags.append(allowedTags[indexPath.item])
            })
            UserData.shared.tags = tags
        }
        
        let alert = UIAlertController(title: nil, message: "Settings Things...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(style: .gray)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        loadingIndicator.anchor(left: alert.view.leadingAnchor, paddingLeft: 20, height: 50, width: 50)
        loadingIndicator.centerY(alert.view.centerYAnchor)
        present(alert, animated: true, completion: nil)

        let userData = try! UserData.shared.asDictionary()
        APIService.userInfoCollection.document(UserData.shared.uid!).setData(userData){ error in
            print("Saving UserInfo")
            if let error = error{
                print("Signup ERROR #3 : \n\n", error)
                return;
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    if let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController{
                        mainTabBarController.setupViewControllers()
                        self.dismiss(animated: true, completion: {
                            let name = Notification.Name(updateUserDataKey)
                            NotificationCenter.default.post(name: name, object: nil)
                        })
                    }
                }
            }
        }
    }
}
