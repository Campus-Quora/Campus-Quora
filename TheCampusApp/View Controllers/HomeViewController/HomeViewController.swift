//
//  HomeViewController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 27/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import Down
import Firebase

class HomeViewController: ColorThemeObservingViewController{
    let answeredCellID = "answeredCellID"
    let unansweredCellID = "unansweredCellID"
    let footerID = "loadingFooterID"
    
    var maxAnswerSize: CGSize!
    var maxQuestionSize: CGSize!
    var estimatedWidth: CGFloat!
    
    let postsTableView = UITableView(frame: .zero, style: .grouped)
    let tagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let tags = ["All", "General", "CSEA", "Coding Club", "CSE Department", "CSE 2022"]
    let tagCellID = "tagCellID"
    lazy var footer = LoadingFooterView()
    
    var fetchingFeed: Bool = false
    var allFetched: Bool = false
    var lastDoc: DocumentSnapshot? = nil
    var batchSize: Int = 4
    var count: Int = 0
    var initialDataSize: Int = 6

//    lazy var refreshView: UIRefreshControl = {
//        let control = UIRefreshControl()
//        control.backgroundColor = selectedTheme.secondaryPlaceholderColor.withAlphaComponent(0.1)
//        control.tintColor = selectedAccentColor.primaryColor
//        control.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
//        return control
//    }()
    
    var detailVCFirstLoad = true
    var postsData: [CompletePost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        footer.tableView = postsTableView
        footer.fetchingMore = true
        postsTableView.contentInsetAdjustmentBehavior = .always // Fixes a bug with navigation transition
//        postsTableView.refreshControl = refreshView
        postsTableView.delegate = self;
        postsTableView.dataSource = self;
        postsTableView.register(UnansweredPostCell.self, forCellReuseIdentifier: unansweredCellID)
        postsTableView.register(AnsweredPostCell.self, forCellReuseIdentifier: answeredCellID)
        postsTableView.register(LoadingFooterView.self, forHeaderFooterViewReuseIdentifier: footerID)
        postsTableView.tableFooterView = UIView(frame: .zero)
        postsTableView.estimatedSectionFooterHeight = 90
        
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        tagsCollectionView.register(TagCell.self, forCellWithReuseIdentifier: tagCellID)
        
        setupData()
        setupUI()
        setupColors()
    }
    
    func setupData(){
        lastDoc = nil
        if(fetchingFeed){
//            self.refreshView.endRefreshing()
            return
        }
        fetchingFeed = true
        self.footer.fetchingMore = true
        APIService.fetchUserFeed(initialSize: initialDataSize){(success, feed, lastDoc) in
            self.fetchingFeed = false
            if(success){
                print("Fetched Feed")
                self.postsData = feed
                self.lastDoc = lastDoc
                DispatchQueue.main.async{
//                    self.refreshView.endRefreshing()
                    self.postsTableView.reloadData()
                    if(feed.count == 0){
                        self.allFetched = true
                        self.footer.fetchingMore = false
                    }
                    else{
                        self.scrollViewDidScroll(self.postsTableView)
                    }
                }
            }
            else{
                DispatchQueue.main.async{
//                    self.refreshView.endRefreshing()
                    self.footer.errorLoading = true;
                }
            }
        }
    }
    func paginateData(){
        fetchingFeed = true
        self.footer.fetchingMore = true
        APIService.paginateUserFeed(after: lastDoc, batchSize: batchSize) { (success, feed, lastDoc) in
            self.fetchingFeed = false
            if(success){
                print("Paginated Feed")
                let oldcount = self.postsData.count
                self.postsData.append(contentsOf: feed)
                self.lastDoc = lastDoc
                DispatchQueue.main.async{
//                    self.refreshView.endRefreshing()
                    var indexPaths = [IndexPath]()
                    let newcount = self.postsData.count
                    for i in oldcount ..< newcount{
                        indexPaths.append(IndexPath(row: i, section: 0))
                    }
                    self.postsTableView.insertRows(at: indexPaths, with: .fade)
                    if(feed.count == 0){
                        self.allFetched = true
                        self.footer.fetchingMore = false
                    }
                    else{
                        self.scrollViewDidScroll(self.postsTableView)
                    }
                }
            }
            else{
                DispatchQueue.main.async{
//                    self.refreshView.endRefreshing()
                    self.footer.errorLoading = true;
                }
            }
        }
    }
    override func setupNavigationBar(){
        super.setupNavigationBar()
        navigationItem.title = "Home"
    }
    
    func setupColors(){
        view.backgroundColor = selectedTheme.primaryColor
        postsTableView.backgroundColor = selectedTheme.primaryColor
        tagsCollectionView.backgroundColor = selectedTheme.secondaryPlaceholderColor.withAlphaComponent(0.1)
    }
    
    func setupUI(){
        tagsCollectionView.showsHorizontalScrollIndicator = false
        tagsCollectionView.bounces = false
        
        view.addSubview(postsTableView)
        view.addSubview(tagsCollectionView)
        tagsCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, height: 55)
        postsTableView.anchor(top: tagsCollectionView.bottomAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, right: view.safeAreaLayoutGuide.trailingAnchor)
        postsTableView.separatorStyle = .none
    }
    
    override func updateTheme() {
        setupColors()
    }
    
    override func updateAccentColor() {
    }
    
    @objc func handleRefresh(){
        setupData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if(!(fetchingFeed || allFetched) && (offsetY > contentHeight - scrollView.frame.height)){
            paginateData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(postsData[indexPath.row].topAnswer == nil){
            let cell = tableView.dequeueReusableCell(withIdentifier: unansweredCellID) as! UnansweredPostCell
            cell.postData = postsData[indexPath.row]
            if(indexPath.row) == 0{
                cell.seperator.alpha = 0
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: answeredCellID) as! AnsweredPostCell
            cell.postData = postsData[indexPath.row]
            if(indexPath.row) == 0{
                cell.seperator.alpha = 0
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = PostDetailViewController(style: .grouped)
        detailVC.data = postsData[indexPath.item]
        self.navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footer
    }
}

//        APIService.postsCollection.addSnapshotListener { (snapshot, error) in
//            if(error != nil){
//                print("#1 Error listening snapshot")
//                return
//            }
//
//            guard let snapshot = snapshot else{return}
//            do{
//                let newEntrys: [CompletePost] = try snapshot.decoded()
//                let oldCount = self.postsData.count
//                self.postsData += newEntrys
//                let newCount = self.postsData.count
//                let indexPaths = Array(oldCount ..< newCount).map { IndexPath(item: $0, section: 0)}
//                DispatchQueue.main.async {
//                    self.postsTableView.insertItems(at: indexPaths)
//                }
//            }
//            catch{
//                print("#2 Error decoding listened snapshot")
//            }
//        }


//        let postData1 = CompletePost()
//        postData1.question = "This is a simple Question"
//        postData1.topAnswer = "This is a simple Answer. Click This cell to expand it"
//        postData1.topAnswerUserName = "Harsh Motwani"
//        postData1.dateAnswered = Date()
//
//        let postData2 = CompletePost()
//        postData2.question = "This is a simple Question. Can Anyone Please answer it"
//        postData2.topAnswer = "This is a complex Answer such that it can occupy more space. Click This cell to expand it"
//        postData2.topAnswerUserName = "Yogesh Kumar"
//        postData2.dateAnswered = Date()
//
//        let postData3 = CompletePost()
//        postData3.question = "This is a simple Question. Can Anyone Please answer it"
//        postData3.topAnswer = "This is a complex Answer such that it can occupy more space. But This thime I have increased it such that it can occupy three lines. Click This cell to expand it"
//        postData3.topAnswerUserName = "Yogesh Kumar"
//        postData3.dateAnswered = Date()
//
//        let postData4 = CompletePost()
//        postData4.question = "This is a complex Question. It occupies three lines so it must be cut to two lines followed by ... Can Anyone Please answer it"
//        postData4.topAnswer = "This is a complex Answer such that it can occupy more space. But This thime I have increased it such that it can occupy four lines. It must be cut to two lines followed by ... Click This cell to expand it"
//        postData4.topAnswerUserName = "Yogesh Kumar"
//        postData4.dateAnswered = Date()
//
//        postsData.append(postData1)
//        postsData.append(postData2)
//        postsData.append(postData3)
//        postsData.append(postData4)
//    }


//fetchingFeed = true
//DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//    self.fetchingFeed = false
//    var indexPaths = [IndexPath]()
//    for i in self.count ..< self.count + self.batchSize {
//        indexPaths.append(IndexPath(row: i, section: 0))
//    }
//    self.count += self.batchSize
//    self.postsTableView.insertRows(at: indexPaths, with: .fade)
//    if(self.count >= 14){
//        self.allFetched = true
//        self.footer.fetchingMore = false
//    }
//    self.scrollViewDidScroll(self.postsTableView)
//}

//if(fetchingFeed || allFetched){ return }
//        fetchingFeed = true
//        self.footer.fetchingMore = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.fetchingFeed = false
//            self.count = self.initialDataSize
////            var indexPaths = [IndexPath]()
////            for i in 0 ..< self.count{
////                indexPaths.append(IndexPath(row: i, section: 0))
////            }
////            self.postsTableView.insertRows(at: indexPaths, with: .fade)
//            self.postsTableView.reloadData()
//            if(self.count >= 20){
//                self.allFetched = true
//                self.footer.fetchingMore = false
//            }
//            self.scrollViewDidScroll(self.postsTableView)
//        }
