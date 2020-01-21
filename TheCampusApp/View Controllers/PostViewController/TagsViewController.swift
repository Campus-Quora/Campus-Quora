//
//  TagsViewController.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 19/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit

class TagsViewController: UIViewController{
    let tagLimit = 5
    let cancelButton = UIButton()
    let submitButton = UIButton()
    var tagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    var completionHandler: (([String])->Void)?
    
    var selectedTagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    let searchController = UISearchController(searchResultsController: nil)
    
    let tagCellID = "tagCellID"
    var selectedTags = [String]()
    var allTags = allowedTags
    var searchedTags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupColors()
        
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        selectedTagsCollectionView.delegate = self
        selectedTagsCollectionView.dataSource = self
        tagsCollectionView.register(TagCell.self, forCellWithReuseIdentifier: tagCellID)
        selectedTagsCollectionView.register(TagCell.self, forCellWithReuseIdentifier: tagCellID)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return selectedTheme.statusBarStyle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "Select Tags"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: submitButton)
        guard let navBar = navigationController?.navigationBar else{return}
        navBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupUI(){
        // Cancel Button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.layer.cornerRadius = 10;
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        cancelButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        // Submit Button
        submitButton.setTitle("Submit", for: .normal)
        submitButton.layer.cornerRadius = 10;
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        submitButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        submitButton.isEnabled = false
        
        // Table View
        tagsCollectionView.showsVerticalScrollIndicator = false
        selectedTagsCollectionView.showsHorizontalScrollIndicator = false
        selectedTagsCollectionView.bounces = false
        
        // Search Bar
        searchController.obscuresBackgroundDuringPresentation = false
        if #available(iOS 13.0, *) {
            searchController.automaticallyShowsCancelButton = true
        }
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchedTags = allTags
        
    }
    
    func setupConstraints(){
        view.addSubview(selectedTagsCollectionView)
        view.addSubview(tagsCollectionView)
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        selectedTagsCollectionView.anchor(top: safeLayoutGuide.topAnchor, left: safeLayoutGuide.leadingAnchor, right: safeLayoutGuide.trailingAnchor, height: 55)
        tagsCollectionView.anchor(top: selectedTagsCollectionView.bottomAnchor, bottom: safeLayoutGuide.bottomAnchor, left: selectedTagsCollectionView.leadingAnchor, right: selectedTagsCollectionView.trailingAnchor, paddingTop: 10, paddingBottom: 10)
    }
    
    func setupColors(){
        view.backgroundColor = selectedTheme.primaryColor
        cancelButton.backgroundColor = selectedTheme.secondaryPlaceholderColor
        submitButton.backgroundColor = selectedAccentColor.primaryColor
        submitButton.tintColor = selectedTheme.primaryColor
        cancelButton.tintColor = selectedTheme.primaryTextColor
        tagsCollectionView.backgroundColor = selectedTheme.primaryColor
        selectedTagsCollectionView.backgroundColor = selectedTheme.secondaryPlaceholderColor.withAlphaComponent(0.2)
        searchController.searchBar.tintColor = selectedTheme.secondaryTextColor
    }
    
        
    @objc func handleCancel(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSubmit(){
        if(selectedTags.count == 0){
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            let alertController = UIAlertController(title: "Empty Tag List", message: "Add atleast one tag", preferredStyle: .alert)
            alertController.addAction(action)
            present(alertController, animated: true)
            return
        }
        completionHandler?(selectedTags)
        handleCancel()
    }
    
    func filterTags(searchString: String){
        if(searchString.count > 0){
            let search = searchString.replacingOccurrences(of: " ", with: "").lowercased()
            searchedTags = allTags.filter { (tag) -> Bool in
                let normalisedTag = tag.replacingOccurrences(of: " ", with: "").lowercased()
                return normalisedTag.contains(search)
            }
            tagsCollectionView.reloadData()
        }
        else{
            restoreSearchedTags()
        }
    }
    
    func restoreSearchedTags(){
        searchedTags = allTags
        tagsCollectionView.reloadData()
    }
}


extension TagsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == tagsCollectionView){
            return searchedTags.count
        }
        return selectedTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellID, for: indexPath)
        if let tagCell = cell as? TagCell{
            if(collectionView == tagsCollectionView){
                tagCell.tagLabel.text = searchedTags[indexPath.item]
            }
            else{
                tagCell.tagLabel.text = selectedTags[indexPath.item]
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag: String
        if(collectionView == tagsCollectionView){
            tag = searchedTags[indexPath.item]
        }
        else{
            tag = selectedTags[indexPath.item]
        }
        var size = tag.size(withAttributes: [.font : UIFont.systemFont(ofSize: 14)
        ])
        size.width += 20
        size.height += 15
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == tagsCollectionView){
            if(selectedTags.count >= tagLimit){
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                let alertController = UIAlertController(title: "Limit Exceed", message: "You can only add upto \(tagLimit) tags", preferredStyle: .alert)
                alertController.addAction(action)
                present(alertController, animated: true)
                return
            }
            selectedTags.append(searchedTags[indexPath.item])
            allTags.removeAll { (tag) -> Bool in
                return tag == searchedTags[indexPath.item]
            }
            searchedTags.remove(at: indexPath.item)
            selectedTagsCollectionView.reloadData()
            tagsCollectionView.reloadData()
        }
        else{
            let item = selectedTags[indexPath.item]
            allTags.append(item)
            selectedTags.remove(at: indexPath.item)
            selectedTagsCollectionView.reloadData()
            if let searchText = searchController.searchBar.text{
                if(searchText.isEmpty){
                    searchedTags.append(item)
                    tagsCollectionView.reloadData()
                }
                else{
                    let search = searchText.replacingOccurrences(of: " ", with: "").lowercased()
                    let normalisedTag = item.replacingOccurrences(of: " ", with: "").lowercased()
                    if(normalisedTag.contains(search)){
                        searchedTags.append(item)
                        tagsCollectionView.reloadData()
                    }
                }
            }
        }
    }
}

extension TagsViewController: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterTags(searchString: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        if let searchText = searchController.searchBar.text{
            filterTags(searchString: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        restoreSearchedTags()
    }
}
