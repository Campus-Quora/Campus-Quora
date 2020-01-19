////
////  PostDetailViewController.swift
////  TheCampusApp
////
////  Created by Yogesh Kumar on 10/01/20.
////  Copyright © 2020 Harsh Motwani. All rights reserved.
////
//
import UIKit
//import Firebase
//
enum AppreciationType{
    case none
    case like
    case dislike
}

//protocol OverflowDelegate: class {
//    func onOverflowEnded()
//    func onOverflow(delta: CGFloat)
//}
//
///// State of overflow of scrollView
/////
///// - on: The scrollview is overflowing : ScrollViewA should take the lead. We store the last trnaslation of the gesture
///// - off: No overflow detected
//enum OverflowState {
//    case on(lastRecordedGestureTranslation: CGFloat)
//    case off
//
//    var isOn: Bool {
//        switch self {
//        case .on:
//            return true
//        case .off:
//            return false
//        }
//    }
//}
//
//class ScrollingStackContainer: ColorThemeObservingViewController, UIScrollViewDelegate{
//    
//    var viewControllers: [StackContainable]!{
//        willSet(newValue){
//            self.removeAllViewControllers()
//            self.items = newValue.map {vc in StackItem(vc as! UIViewController, vc.preferredAppearanceInStack())}
//        }
//    }
//    
//    var items: [StackItem] = []
//    
//    func removeAllViewControllers() {
//        self.items.forEach { vc in
//            vc.controller.willMove(toParent: nil)
//            vc.controller.removeFromParent()
//            vc.controller.view.removeFromSuperview()
//        }
//        self.items.removeAll()
//    }
//    
//    let scrollView = UIScrollView()
//    var screenHeight: CGFloat!
//    var scrollViewContentHeight: CGFloat!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.addSubview(scrollView)
//        scrollView.fillSuperView()
//        
//        screenHeight = UIScreen.main.bounds.height
//        scrollViewContentHeight = 1200
//        
//        scrollView.delegate = self
//        scrollView.bounces = false
//        
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//    }
//}
//
//class PostDetailViewController: ColorThemeObservingViewController, UIScrollViewDelegate, OverflowDelegate{
//    func onOverflowEnded() {
//        // scroll to top if at least one third of the overview is showed (you can change this fraction as you please ^^)
//        let shouldScrollToTop = (scrollView.contentOffset.y <= 2 * scrollView.frame.height / 3)
//        if shouldScrollToTop {
//            scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
//        } else {
//            scrollView.scrollRectToVisible(CGRect(x: 0, y: scrollView.contentSize.height - 1, width: 1, height: 1), animated: true)
//        }
//    }
//
//    func onOverflow(delta: CGFloat) {
//        // move the scrollview content
//        if scrollView.contentOffset.y - delta <= scrollView.contentSize.height - scrollView.frame.height {
//            scrollView.contentOffset.y -= delta
//            print("difference : \(delta)")
//            print("contentOffset : \(scrollView.contentOffset.y)")
//        }
//    }
//    
//    let scrollView = UIScrollView()
//    let contentView = UIView()
//    
//    var data: CompletePost?{
//        didSet{
//            questionController.data = data
//            answerController.data = data
//        }
//    }
//    
//    let questionController = PostDetailQuestionViewController()
//    let answerController = PostDetailAnswerViewController()
//    var screenHeight: CGFloat!
//    var scrollViewContentHeight: CGFloat!
//    
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let yoffset = scrollView.contentOffset.y
//        let height = questionController.view.bounds.height
//        if scrollView == self.scrollView && yoffset >= height + 20{
//            scrollView.isScrollEnabled = false
//            answerController.tableView.isScrollEnabled = true
//        }
//        
//        
////        print(yoffset)
////        if scrollView == answerController.tableView && yoffset < height{
////            self.scrollView.isScrollEnabled = true
////            answerController.tableView.isScrollEnabled = false
////        }
//    }
//    
//    func setupViews(){
//        answerController.delegate = self
////        scrollViewContentHeight = 1000
//        screenHeight = UIScreen.main.bounds.height
//        scrollView.delegate = self
//        scrollView.bounces = false
//        questionController.willMove(toParent: self)
//        questionController.containerViewController = self
//        self.addChild(questionController)
//        
//        answerController.containerScrollView = self.scrollView
//        answerController.willMove(toParent: self)
//        self.addChild(answerController)
//        
//        
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//        contentView.addSubview(questionController.view)
//        contentView.addSubview(answerController.tableView)
//        
////        scrollView.showsVerticalScrollIndicator = false
//        scrollView.fillSuperView()
//        contentView.fillSuperView()
//        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
////        print(self.view.frame)
////        contentView.heightAnchor.constraint(equalToConstant: scrollViewContentHeight).isActive = true
//        
//        questionController.view.anchor(top: contentView.topAnchor, left: contentView.leadingAnchor, right: contentView.trailingAnchor, paddingTop: 0, paddingLeft: 10, paddingRight: 10)
//        questionController.view.sizeToFit()
////        questionController.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        answerController.tableView.anchor(top: questionController.view.bottomAnchor, bottom: contentView.bottomAnchor, left: contentView.leadingAnchor, right: contentView.trailingAnchor, paddingTop: 10, paddingBottom: 10)
////        questionController.scrollView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
//        answerController.tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
////        answerController.tableView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//        setupColors()
//        
//        let newAnswer1 = Answers(userID: "1234", userName: "Tanishka", userProfilePicURLString: "", answerURLString: "")
//        newAnswer1.dateAnswered = Date()
//        let newAnswer2 = Answers(userID: "1234", userName: "Yogesh", userProfilePicURLString: "", answerURLString: "")
//        newAnswer2.dateAnswered = Date()
//        
//        data?.answers.append(newAnswer1)
//        data?.answers.append(newAnswer2)
//        data?.answers.append(newAnswer1)
//        data?.answers.append(newAnswer2)
//        data?.answers.append(newAnswer1)
//        data?.answers.append(newAnswer2)
//        
//        // Add Notification Observer
//        var name = Notification.Name(changeThemeKey)
//        NotificationCenter.default.addObserver(self, selector: #selector(didChangeTheme), name: name, object: nil)
//        
//        name = Notification.Name(changeAccentColorKey)
//        NotificationCenter.default.addObserver(self, selector: #selector(didChangeAccentColor), name: name, object: nil)
//    }
//    
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//        return selectedTheme.statusBarStyle
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setupNavigationBar()
//    }
//
//    override func setupNavigationBar(){
//        guard let navBar = navigationController?.navigationBar else {return}
//        if #available(iOS 11.0, *) {
//            navBar.prefersLargeTitles = false
//        }
//        navBar.shadowImage = UIImage()
//        navBar.isTranslucent = false
//        navigationItem.title = ""
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
//        handleNavBarColors()
//    }
//    
//    lazy var backButton: UIButton = {
//        let button = UIButton()
//        let size = CGSize(width: 30, height: 30)
//        let image = UIImage(named: "Cancel")?.resizeImage(size: size).withRenderingMode(.alwaysTemplate)
//        button.setImage(image, for: .normal)
//        button.tintColor = .black
//        button.addTarget(self, action: #selector(SettingsViewController.dismissVC), for: .touchUpInside)
//        return button
//    }()
//    
//    func setupColors(){
//        backButton.tintColor = selectedAccentColor.primaryColor
//    }
//    
//    override func updateTheme() {
//        setupColors()
//        questionController.setupColors()
//        answerController.setupColors()
//    }
//    
//    override func updateAccentColor() {
//        backButton.tintColor = selectedAccentColor.primaryColor
//        questionController.updateAccentColor()
//        answerController.updateAccentColor()
//    }
//    
//    override func updateColors() {
//        setupColors()
//    }
//    
//    func loadAnswers(forceLoad: Bool){
//        if(!forceLoad && data!.answers.count > 0){return}
//        let db = Firestore.firestore()
//        db.collection("posts").document(data!.postID!).collection("answers").getDocuments { (querySnapshot, error) in
//            if(error != nil){
//                print("Error Reading Answers #1")
//                return
//            }
//            
//            for document in querySnapshot!.documents{
//                print(document.documentID)
//                print(document.data())
//            }
//        }
//        
//        // Load Asker Picture
//        // Load Question Description
//    }
//
//    @objc func dismissVC(){
//        navigationController?.popViewController(animated: true)
//    }
//    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//}
//
//class PostDetailAnswerViewController: UITableViewController, UIGestureRecognizerDelegate{
//    var answers = [NSAttributedString]()
//    var data: CompletePost?
//    let answerCellID = "answerCellID"
//    weak var delegate: OverflowDelegate?
//    var customPanGesture: UIPanGestureRecognizer!
//    var overflowState = OverflowState.off
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupColors()
//        print("Called")
//        
//        customPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panRecognized(gesture:)))
//        tableView.addGestureRecognizer(customPanGesture)
//        customPanGesture.delegate = self
//        
//        // Dummy Data
//        let str1 = NSAttributedString(string: "This is a very very long answer. Why even bother reading it, just focus on programming. Beta 1.\nBet2\nBet3.\nSttill Here!!! Okay No Problem.\n")
//        let str2 = NSAttributedString(string: "This is a very very long answer. Why even bother reading it, just focus on programming")
//        answers.append(str1)
//        answers.append(str2)
//        answers.append(str1)
//        answers.append(str2)
//        answers.append(str1)
//        answers.append(str2)
//        
//        tableView.isScrollEnabled = false
//        tableView.register(AnswerCell.self, forCellReuseIdentifier: answerCellID)
//    }
//    
//    var containerScrollView: UIScrollView?
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if(scrollView.contentOffset.y <= 0){
//            if !overflowState.isOn {
//                //            tableView.isScrollEnabled = false
//                //            containerScrollView?.isScrollEnabled = true
//                let translation = self.customPanGesture.translation(in: self.view)
//                self.overflowState = .on(lastRecordedGestureTranslation: translation.y)
//
//                // disable scroll as we don't scroll in this scrollView from now on
//                scrollView.panGestureRecognizer.isEnabled = false
//            }
//        }
//    }
//    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true // so that both the pan gestures on scrollview will be triggered
//    }
//    
//    @objc func panRecognized(gesture: UIPanGestureRecognizer) {
//        switch overflowState {
//        case .on(let lastRecordedGestureTranslation):
//            // the user just released his finger
//            if gesture.state == .ended {
//                delegate?.onOverflowEnded() // warn delegate
//                overflowState = .off // end of overflow
//                tableView.panGestureRecognizer.isEnabled = true // enable scroll again
//                return
//            }
//
//            // compute the translation delta & send it to delegate
//            let fullTranslationY = gesture.translation(in: view).y
//            let delta = fullTranslationY - lastRecordedGestureTranslation
//            overflowState = .on(lastRecordedGestureTranslation: fullTranslationY)
//            delegate?.onOverflow(delta: delta)
//        case .off:
//            return
//        }
//    }
//
//    
//    func setupColors(){
//        
//    }
//    
//    public func preferredAppearanceInStack() -> ScrollingStackController.ItemAppearance {
//        let _ = self.view // force load of the view
//        return .scroll(self.tableView!, insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data!.answers.count
//    }
//        
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: answerCellID, for: indexPath) as? AnswerCell else{return UITableViewCell()}
//        // Load Answer NSAttributedString if not available
//        if(answers.count <= indexPath.row){
//            // Load answer
//            return UITableViewCell()
//        }
//        
//        cell.answer = data?.answers[indexPath.row]
//        cell.answerLabel.attributedText = answers[indexPath.row]
//        return cell
//    }
//    
//}
//
//class PostDetailQuestionViewController: UIViewController, StackContainable{
//    let questionLabel = UILabel()
//    let descriptionLabel = UILabel()
//    let askerPictureView = DetailPictureView()
//    let upvoteButton = VerticalButton()
//    let downvoteButton = VerticalButton()
//    let expandButton = UIButton()
//    let seperator = UIView()
//    var controlStack: UIStackView!
////    let scrollView = UIScrollView()
//    var containerViewController: PostDetailViewController?
//    var isExpanded = false
//    var descriptionViewBottomConstraint: NSLayoutConstraint!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupColors()
//        setupConstraints()
//    }
//
//    var data: CompletePost?{
//        didSet{
////            loadAnswers(forceLoad: false)
//            questionLabel.text = data!.question
//            descriptionLabel.text = data!.topAnswer
//            askerPictureView.personWhoAnswered = data!.topAnswerUserName
//            askerPictureView.date = data!.dateAnswered?.userReadableDate()
//        }
//    }
//    
////    public func preferredAppearanceInStack() -> ScrollingStackController.ItemAppearance {
////        let _ = self.view // force load of the view
////        return .scroll(self.scrollView, insets: UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10))
////    }
//
//    var apprType: AppreciationType = .none{
//        willSet(newValue){
//            switch(apprType){
//                case .none: break
//                case .like: upvoteButton.tintColor = selectedTheme.secondaryPlaceholderColor
//                case .dislike: downvoteButton.tintColor = selectedTheme.secondaryPlaceholderColor
//            }
//            switch(newValue){
//                case .none: break
//                case .like: upvoteButton.tintColor = selectedAccentColor.primaryColor
//                case .dislike: downvoteButton.tintColor = selectedAccentColor.primaryColor
//            }
//        }
//    }
//    
//    func setupColors(){
//        view.backgroundColor = selectedTheme.primaryColor
//        questionLabel.textColor = selectedTheme.primaryTextColor
//        descriptionLabel.textColor = selectedTheme.primaryTextColor
//        askerPictureView.dateLabel.textColor = selectedTheme.primaryTextColor
//        askerPictureView.detailsLabel.textColor = selectedTheme.primaryTextColor
//        upvoteButton.setTitleColor(selectedTheme.secondaryPlaceholderColor, for: .normal)
//        downvoteButton.setTitleColor(selectedTheme.secondaryPlaceholderColor, for: .normal)
//        upvoteButton.tintColor = selectedTheme.secondaryPlaceholderColor
//        downvoteButton.tintColor = selectedTheme.secondaryPlaceholderColor
//        seperator.backgroundColor = selectedTheme.secondaryTextColor.withAlphaComponent(0.7)
//        expandButton.tintColor = selectedTheme.secondaryPlaceholderColor
//    }
//    
//    func setupConstraints(){
////        view.addSubview(scrollView)
//        view.addSubview(questionLabel)
//        view.addSubview(controlStack)
//        view.addSubview(descriptionLabel)
//        view.addSubview(seperator)
//        
////        scrollView.anchor(top: view.topAnchor, left: view.leadingAnchor)
////        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
////        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//        
////        view.heightAnchor.constraint(equalToConstant: 300).isActive = true
//        // Question Label
//        questionLabel.anchor(top: view.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingLeft: 10, paddingRight: 10)
//        questionLabel.sizeToFit()
//        
//        // Control Stack
//        controlStack.anchor(top: questionLabel.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 5, paddingLeft: 10, paddingRight: 15, height: 50)
//        
//        // Description Label
//        descriptionLabel.anchor(top: controlStack.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
//        descriptionLabel.sizeToFit()
//        descriptionViewBottomConstraint = descriptionLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor)
//        descriptionViewBottomConstraint.isActive = true
//        
//        // Seperator
//        seperator.anchor(top: descriptionLabel.bottomAnchor, bottom: view.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, paddingTop: 10, height: 2)
//    }
//    
//    func setupUI(){
//        // Upvote Button
//        let upvoteImage = UIImage(named: "Like")?.withRenderingMode(.alwaysTemplate)
//        upvoteButton.setImage(upvoteImage, for: .normal)
//        upvoteButton.setTitle("12.4K", for: .normal)
//        upvoteButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
//        upvoteButton.addTarget(self, action: #selector(handleUpvote), for: .touchUpInside)
//        upvoteButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        
//        // Downvote Button
//        let downvoteImage = UIImage(named: "Dislike")?.withRenderingMode(.alwaysTemplate)
//        downvoteButton.setImage(downvoteImage, for: .normal)
//        downvoteButton.setTitle("203", for: .normal)
//        downvoteButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
//        downvoteButton.addTarget(self, action: #selector(handleDownvote), for: .touchUpInside)
//        downvoteButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        
//        // Expnad Button
//        let expandImage = UIImage(named: "Expand")?.resizeImage(size: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
//        expandButton.setImage(expandImage, for: .normal)
//        expandButton.addTarget(self, action: #selector(handleDescription), for: .touchUpInside)
//        expandButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
//       
//        // Stack
//        let innerstack = UIStackView(arrangedSubviews: [upvoteButton, downvoteButton])
//        innerstack.axis = .horizontal
//        innerstack.alignment = .trailing
//        innerstack.spacing = 5
//        
//        // Control Stack
//        controlStack = UIStackView(arrangedSubviews: [askerPictureView, innerstack, expandButton])
//        controlStack.axis = .horizontal
//        controlStack.distribution = .equalSpacing
//        
//        // Question Label
//        questionLabel.numberOfLines = 0
//        questionLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
//        
//        // Question Description
//        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
//        descriptionLabel.numberOfLines = 0
//    }
//    
//    @objc func handleDescription(){
//        if(isExpanded){
//            self.descriptionViewBottomConstraint.isActive = true
//            UIView.animate(withDuration: 0.5) {
//                self.descriptionLabel.alpha = 0
//                self.view.layoutIfNeeded()
//                self.containerViewController?.scrollView.layoutIfNeeded()
//                self.expandButton.transform = .identity
//            }
//        }
//        else{
//            self.descriptionViewBottomConstraint.isActive = false
//            UIView.animate(withDuration: 0.5) {
//                self.descriptionLabel.alpha = 1
//                self.view.layoutIfNeeded()
//                self.containerViewController?.scrollView.layoutIfNeeded()
//                self.expandButton.transform = self.expandButton.transform.rotated(by: 0.99 * CGFloat.pi)
//            }
//        }
//        isExpanded = !isExpanded
//    }
//    
//    @objc func handleUpvote(){
//        apprType = ((apprType == .like) ? .none: .like)
//    }
//    
//    @objc func handleDownvote(){
//        apprType = ((apprType == .dislike) ? .none: .dislike)
//    }
//    
//    override func updateAccentColor() {
//        switch(apprType){
//            case .none: break
//            case .like: upvoteButton.tintColor = selectedAccentColor.primaryColor
//            case .dislike: downvoteButton.tintColor = selectedAccentColor.primaryColor
//        }
//    }
//}
//
//
//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//struct PostDetailViewRepresentable: UIViewRepresentable {
//    func makeUIView(context: Context) -> UIView {
//        let vc = PostDetailViewController()
//        let postData4 = CompletePost()
//        postData4.question = "This is a complex Question. It occupies three lines so it must be cut to two lines followed by ... Can Anyone Please answer it"
//        postData4.topAnswer = "This is a complex Answer such that it can occupy more space. But This thime I have increased it such that it can occupy four lines. It must be cut to two lines followed by ... Click This cell to expand it"
//        postData4.topAnswerUserName = "Yogesh Kumar"
//        postData4.dateAnswered = Date()
//        vc.data = postData4
//        return vc.view
//    }
//    
//    func updateUIView(_ view: UIView, context: Context) {
//        
//    }
//}
//
//@available(iOS 13.0, *)
//struct PostDetailViewRepresentable_Preview: PreviewProvider {
//    static var previews: some View {
//        PostDetailViewRepresentable()
//        
//    }
//}
//#endif
