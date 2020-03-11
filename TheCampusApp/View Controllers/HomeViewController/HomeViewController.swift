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
    
    var tags = [String]()
    var selectedTag: String!
    var selectedTagIndex: Int!
    let tagCellID = "tagCellID"
    lazy var footer = LoadingFooterView()
    
    var fetchingFeed = [String: Bool]()
    var allFetched = [String: Bool]()
    var lastDoc = [String: DocumentSnapshot]()
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
    
    var postsData = [String: [CompletePost]]()
    
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
        
        setupUI()
        setupColors()
        
        let name = Notification.Name(updateUserDataKey)
        NotificationCenter.default.addObserver(self, selector: #selector(setupTags), name: name, object: nil)
    }
    
    @objc func setupTags(){
        self.tags = UserData.shared.tags ?? ["All"]
        let indexPath = IndexPath(item: 0, section: 0)
        self.selectedTag = self.tags[indexPath.item]
        self.selectedTagIndex = indexPath.item
        tagsCollectionView.reloadData()
        tagsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        setupData()
    }
    
    func setupData(){
        lastDoc[selectedTag] = nil
        allFetched[selectedTag] = false
        if((fetchingFeed[selectedTag] ?? false) == true){
//            self.refreshView.endRefreshing()
            return
        }
        if(postsData[selectedTag] != nil){
            fetchingFeed[selectedTag] = false
            allFetched[selectedTag] = true
            UIView.performWithoutAnimation {
                self.postsTableView.reloadData()
            }
            self.footer.fetchingMore = false
            return
        }
        fetchingFeed[selectedTag] = true
        self.postsTableView.reloadData()
        self.footer.fetchingMore = true
        APIService.fetchUserFeed(initialSize: initialDataSize, tag: self.selectedTag){(tag, success, feed, lastDoc) in
            self.fetchingFeed[tag] = false
            if(success){
                print("Fetched Feed")
                self.postsData[tag] = feed
                self.lastDoc[tag] = lastDoc
                if(tag != self.selectedTag){return}
                DispatchQueue.main.async{
//                    self.refreshView.endRefreshing()
                    self.postsTableView.reloadData()
                    if(feed.count == 0){
                        self.allFetched[self.selectedTag] = true
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
        fetchingFeed[selectedTag] = true
        self.footer.fetchingMore = true
        APIService.paginateUserFeed(after: lastDoc[selectedTag], batchSize: batchSize, tag: self.selectedTag){ (tag, success, feed, lastDoc) in
            self.fetchingFeed[tag] = false
            if(success){
                print("Paginated Feed")
                let oldcount = self.postsData.count
                self.postsData[tag]?.append(contentsOf: feed)
                self.lastDoc[tag] = lastDoc
                if(tag != self.selectedTag){return}
                DispatchQueue.main.async{
//                    self.refreshView.endRefreshing()
                    var indexPaths = [IndexPath]()
                    let newcount = self.postsData.count
                    for i in oldcount ..< newcount{
                        indexPaths.append(IndexPath(row: i, section: 0))
                    }
                    self.postsTableView.insertRows(at: indexPaths, with: .fade)
                    if(feed.count == 0){
                        self.allFetched[self.selectedTag] = true
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
    
    // Called when user signs out
    func cleanUP(){
        fetchingFeed = [String: Bool]()
        allFetched = [String: Bool]()
        lastDoc = [String: DocumentSnapshot]()
        tags = [String]()
        postsData = [String: [CompletePost]]()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let fetching = self.fetchingFeed[selectedTag] ?? false
        let alldone = self.allFetched[selectedTag] ?? false
        if(!(fetching || alldone) && (offsetY > contentHeight - scrollView.frame.height)){
            paginateData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.selectedTag == nil){return 0}
        return postsData[self.selectedTag]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(postsData[self.selectedTag]?[indexPath.row].topAnswer == nil){
            let cell = tableView.dequeueReusableCell(withIdentifier: unansweredCellID) as! UnansweredPostCell
            cell.postData = postsData[self.selectedTag]?[indexPath.row]
            if(indexPath.row) == 0{
                cell.seperator.alpha = 0
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: answeredCellID) as! AnsweredPostCell
            cell.postData = postsData[self.selectedTag]?[indexPath.row]
            if(indexPath.row) == 0{
                cell.seperator.alpha = 0
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = PostDetailViewController(style: .grouped)
        detailVC.data = postsData[self.selectedTag]?[indexPath.item]
        self.navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footer
    }
}
