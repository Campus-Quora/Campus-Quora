//
//  ProfileViewController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 27/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

//visibleHeight = UIScreen.main.nativeBounds.height/UIScreen.main.nativeScale - navigationController!.navigationBar.frame.size.height - tabBarController!.tabBar.frame.size.height - UIApplication.shared.statusBarFrame.height

import UIKit
import Firebase

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    let headerID = "headerID"
    let cellID = "cellID"
    var headerHeight: CGFloat = 0
    
    var maxAnswerSize: CGSize!
    var maxQuestionSize: CGSize!
    var estimatedWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        estimateSize()
        setupUI()
        
        // This is used to force collectionView to stick to safe layout
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }
        
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: cellID)
        
        headerHeight = (UIScreen.main.nativeBounds.height/UIScreen.main.nativeScale) * 0.23
        
        setupLogOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    func setupNavigationBar(){
        navigationItem.title = "Profile"
        
        guard let navBar = navigationController?.navigationBar else {return}
        if #available(iOS 11.0, *) {
            navBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
            navigationController?.navigationBar.backgroundColor = .black
            navigationController?.navigationBar.barTintColor = .black
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        }
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = false
        navBar.tintColor = primaryColor
    }
    //log out button
    func setupLogOut(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Settings"), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: "Log Out?", message: "Are you sure you want to Log Out?", preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do{
                try Auth.auth().signOut()
                let loginController = LoginViewController()

                let navController = UINavigationController(rootViewController: loginController)

                self.present(navController, animated: true, completion: nil)
            } catch let signOutError {
                print("Failed to Sign Out: ", signOutError)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
    
    func setupUI(){
        collectionView.backgroundColor = .white
    }
    
    var postsData: [PostData] = []
    func setupData(){
        var postData1 = PostData()
        postData1.question = "This is a simple Question"
        postData1.answer = "This is a simple Answer. Click This cell to expand it"
        postData1.personWhoAnswered = "Harsh Motwani"
        postData1.date = "Nov 21"
        
        var postData2 = PostData()
        postData2.question = "This is a simple Question. Can Anyone Please answer it"
        postData2.answer = "This is a complex Answer such that it can occupy more space. Click This cell to expand it"
        postData2.personWhoAnswered = "Yogesh Kumar"
        postData2.date = "Nov 21"
        
        var postData3 = PostData()
        postData3.question = "This is a simple Question. Can Anyone Please answer it"
        postData3.answer = "This is a complex Answer such that it can occupy more space. But This thime I have increased it such that it can occupy three lines. Click This cell to expand it"
        postData3.personWhoAnswered = "Yogesh Kumar"
        postData3.date = "Nov 21"
        
        var postData4 = PostData()
        postData4.question = "This is a complex Question. It occupies three lines so it must be cut to two lines followed by ... Can Anyone Please answer it"
        postData4.answer = "This is a complex Answer such that it can occupy more space. But This thime I have increased it such that it can occupy four lines. It must be cut to two lines followed by ... Click This cell to expand it"
        postData4.personWhoAnswered = "Yogesh Kumar"
        postData4.date = "Nov 21"
        
        postsData.append(postData1)
        postsData.append(postData2)
        postsData.append(postData3)
        postsData.append(postData4)
    }
}

// MARK:- Extension #2
// This is for collectionViewHeader
extension ProfileViewController{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let width = collectionView.frame.width
        return CGSize(width: width, height: headerHeight)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath)
        return header
    }
}

// MARK:- Extension #2
// This is for collectionViewcells
extension ProfileViewController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsData.count
    }
    
    func estimateSize(){
        estimatedWidth = view.frame.width - 2 * postCellSidePadding
        let maxAnswerHeight = CGFloat(numberOfLinesInAnswer) * String.findSingleLineHeight(width: estimatedWidth, attributes: [.font: answerFont])
        let maxQuestionHeight = CGFloat(numberOfLinesInQuestion) * String.findSingleLineHeight(width: estimatedWidth, attributes: [.font: questionFont])
        maxAnswerSize = CGSize(width: estimatedWidth, height: maxAnswerHeight)
        maxQuestionSize = CGSize(width: estimatedWidth, height: maxQuestionHeight)
        print(maxAnswerHeight, maxQuestionHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = postsData[indexPath.item]
        
        let estimatedAnswerFrame = NSString(string: data.answer ?? "").boundingRect(with: maxAnswerSize, options: .usesLineFragmentOrigin, attributes: [.font : answerFont], context: nil)
        let estimatedQuestionFrame = NSString(string: data.question ?? "").boundingRect(with: maxQuestionSize, options: .usesLineFragmentOrigin, attributes: [.font : questionFont], context: nil)
        print(estimatedAnswerFrame.height, estimatedQuestionFrame.height)
        let estimatedHeight = estimatedAnswerFrame.height + estimatedQuestionFrame.height + 50 + 35 + 15
        return CGSize(width: estimatedWidth, height: estimatedHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        if let cell = cell as? PostCell{
            cell.postData = postsData[indexPath.item]
            if(indexPath.item) == 0{
                cell.seperator.alpha = 0
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
}
