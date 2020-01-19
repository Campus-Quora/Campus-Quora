//
//  PostDetailViewController2.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 12/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit
import Firebase

protocol AnswerDelegate: class {
    func finishedPostingAnswer()
}

class PostDetailViewController: ColorThemeObservingTableViewController{
    var answers = [NSAttributedString]()
    var data: CompletePost?
    let answerCellID = "answerCellID"
    let headerID = "questionHeaderID"
    let footerID = "loadingFooterID"
    
    let backButton = UIButton()
    let answerButton = UIButton()
    let footer = LoadingFooterView()
    lazy var answerVC = AnswerViewController()
    lazy var answerNC = UINavigationController(rootViewController: answerVC)
//    var firstLoad: Bool = true
    
    var fetchingData: Bool = false
    var allFetched: Bool = false
    var batchSize: Int = 1
    var count: Int = 0
    var initialDataSize: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupColors()
        initialise()

        tableView.register(AnswerCell.self, forCellReuseIdentifier: answerCellID)
        tableView.register(PostDetailQuestionView.self, forHeaderFooterViewReuseIdentifier: headerID)
        tableView.register(LoadingFooterView.self, forHeaderFooterViewReuseIdentifier: footerID)
    }
    
    override func setupNavigationBar(){
        super.setupNavigationBar()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: answerButton)
    }

    
    func setupUI(){
        // AnswerButton
        answerButton.setTitle("Answer", for: .normal)
        answerButton.tintColor = .white
        answerButton.layer.cornerRadius = 10;
        answerButton.backgroundColor = selectedAccentColor.primaryColor
        answerButton.addTarget(self, action: #selector(handleAnswer), for: .touchUpInside)
        answerButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        // Back Button
        let image = UIImage(named: "Cancel")?.resizeImage(size: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        // Table View
        footer.fetchingMore = true
        tableView.allowsSelection = false
        tableView.estimatedSectionHeaderHeight = 200
        tableView.estimatedSectionFooterHeight = 90
        tableView.estimatedRowHeight = 200
        tableView.showsVerticalScrollIndicator = false
    }
    
    func setupConstraints(){
        
    }
    
    func initialise(){
//        if(!firstLoad){tableView.reloadData()}
        if self.data == nil {return}
        if(self.data?.answers == nil){
            fetchingData = false
            allFetched = false
            loadAnswersMetadata()
        }
        else if(self.data?.lastDoc == nil){
            allFetched = true
            if(self.data?.answers?.count == 0){
                footer.noAnswers = true
            }
            else{
                footer.fetchingMore = false
            }
        }
    }
    
    func loadAnswersMetadata(forceLoad: Bool = false){
        self.data?.lastDoc = nil
        if(fetchingData){
            return
        }
        if(data?.answers == nil || forceLoad){
            self.fetchingData = true
            self.footer.fetchingMore = true
            APIService.loadAnswersMetadata(for: data!.postID!, initialSize: initialDataSize){ [weak self] (success, postID, answers, lastDoc) in
                guard let self = self else { return }
                self.fetchingData = false
                if(self.data?.postID != postID){ return }
                if(success){
                    print("Fetched Initial Answers Metadata")
                    self.data?.lastDoc = lastDoc
                    self.data?.answers = answers
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else{return}
                        self.tableView.reloadData()
                        if(answers.count == 0){
                            self.allFetched = true
                            self.footer.noAnswers = true
                        }
                        else{
                            self.scrollViewDidScroll(self.tableView)
                        }
                    }
                }
                else{
                    DispatchQueue.main.async { [weak self] in
                        self?.footer.errorLoading = true
                    }
                }
            }
        }
    }
    func paginateAnswersMetadata(){
        self.fetchingData = true
        self.footer.fetchingMore = true
        APIService.paginateAnswersMetadata(for: data!.postID!, after: self.data?.lastDoc, batchSize: batchSize){ [weak self] (success, postID, answers, lastDoc) in
            guard let self = self else { return }
            
            self.fetchingData = false
            if(self.data?.postID != postID){ return }
            if(success){
                print("Paginated Answers")
                self.data?.lastDoc = lastDoc
                let oldcount = self.data?.answers?.count ?? 0
                self.data?.answers?.append(contentsOf: answers)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else{return}
                    var indexPaths = [IndexPath]()
                    let newcount = self.data?.answers?.count ?? 0
                    for i in oldcount ..< newcount{
                        indexPaths.append(IndexPath(row: i, section: 0))
                    }
                    self.tableView.insertRows(at: indexPaths, with: .fade)
                    if(answers.count == 0){
                        self.allFetched = true
                        self.footer.fetchingMore = false
                    }
                }
            }
            else{
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else{return}
                    self.footer.errorLoading = true
                }
            }
        }
    }
    
    @objc func handleAnswer(){
        answerVC.data = data
//        answerVC.delegate = self
        present(answerNC, animated: true)
    }
    
    func setupColors(){
        tableView.backgroundColor = selectedTheme.primaryColor
        backButton.tintColor = selectedAccentColor.primaryColor
    }

    override func updateTheme() {
        tableView.backgroundColor = selectedTheme.primaryColor
    }
    
    override func updateAccentColor() {
        backButton.tintColor = selectedAccentColor.primaryColor
    }
    
    @objc func dismissVC(){
        navigationController?.popViewController(animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Post Detail VC deinit")
    }
}

extension PostDetailViewController{
    override func scrollViewDidScroll(_ scrollView: UIScrollView){
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if(!(fetchingData || allFetched) && (offsetY > contentHeight - scrollView.frame.height)){
            paginateAnswersMetadata()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.answers?.count ?? 0
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: answerCellID, for: indexPath) as? AnswerCell else{return UITableViewCell()}
        // Load Answer NSAttributedString if not available
        cell.answerLabel.attributedText = nil
        cell.answer = nil
        
        if(self.data?.answers?[indexPath.row].answerNSAString == nil){
            self.fetchingData = true
            let url = (data?.answers?[indexPath.row].answerURLString)!
            APIService.loadAnswer(from: url){
                [weak self] (success, fetchedURL, answerData) in
                guard let self = self else { return }
                self.fetchingData = false
                if(fetchedURL != url){
                    print("Wrong Fetch")
                }
                else if(!success){
                    DispatchQueue.main.async { [weak self] in
                        self?.footer.errorLoading = true
                    }
                }
                else{
                    self.data?.answers?[indexPath.row].answerNSAString = answerData.toAttributedString()!
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else{return}
                        cell.answer = self.data?.answers?[indexPath.row]
                        self.tableView.beginUpdates()
                        cell.answerLabel.attributedText = self.data?.answers?[indexPath.row].answerNSAString
                        self.tableView.endUpdates()
                    }
                    if(self.data?.answers?.count == indexPath.row + 1){
                        self.scrollViewDidScroll(self.tableView)
                    }
                }
            }
        }
        else{
            cell.answer = data?.answers?[indexPath.row]
            cell.answerLabel.attributedText = self.data?.answers?[indexPath.row].answerNSAString
            return cell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as? PostDetailQuestionView else {return UITableViewHeaderFooterView()}
        header.data = data
        header.controller =  self
        return header
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.footer
    }
}

extension PostDetailViewController: AnswerDelegate{
    func finishedPostingAnswer(){
        let count = self.data?.answers?.count ?? 0
        let indexPaths = IndexPath(row: count - 1, section: 0)
        print(indexPaths)
        self.tableView.insertRows(at: [indexPaths], with: .automatic)
    }
}

//func loadData(){
//    answers = []
//    data?.answers = []
//    let str1 = NSAttributedString(string: "This is a very very long answer. Why even bother reading it, just focus on programming. Beta 1.\nBet2\nBet3.\nSttill Here!!! Okay No Problem.\n")
//    let str2 = NSAttributedString(string: "This is a very very long answer. Why even bother reading it, just focus on programming")
//    answers.append(str1)
//    answers.append(str2)
//    answers.append(str1)
//    answers.append(str2)
//    answers.append(str1)
//    answers.append(str2)
//
//    let newAnswer1 = Answers(userID: "1234", userName: "Tanishka", userProfilePicURLString: "", answerURLString: "")
//    newAnswer1.dateAnswered = Date()
//    let newAnswer2 = Answers(userID: "1234", userName: "Yogesh", userProfilePicURLString: "", answerURLString: "")
//    newAnswer2.dateAnswered = Date()
//
//    data?.answers?.append(newAnswer1)
//    data?.answers?.append(newAnswer2)
//    data?.answers?.append(newAnswer1)
//    data?.answers?.append(newAnswer2)
//    data?.answers?.append(newAnswer1)
//    data?.answers?.append(newAnswer2)
//}
