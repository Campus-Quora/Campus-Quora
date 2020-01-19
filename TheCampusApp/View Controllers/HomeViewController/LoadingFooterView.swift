//
//  PostDetailFooterView.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 15/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit

class LoadingFooterView: UITableViewHeaderFooterView{
    var spinner = UIActivityIndicatorView(style: .gray)
    let label = UILabel()
    weak var tableView: UITableView?
    
    var fetchingMore: Bool?{
        didSet{
            if fetchingMore == nil || fetchingMore! == false{
                label.text = "Thats all for now"
                spinnerHeightConstraint?.constant = 10
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView?.beginUpdates()
                    self.layoutIfNeeded()
                    self.tableView?.endUpdates()
                    self.spinner.alpha = 0
                }){ _ in
                    self.spinner.stopAnimating()
                }
            }
            else{
                label.text = "Loading More. Please Wait"
                addSubview(spinner)
                spinner.startAnimating()
                spinner.isHidden = false
                spinnerHeightConstraint?.constant = 40
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView?.beginUpdates()
                    self.layoutIfNeeded()
                    self.tableView?.endUpdates()
                    self.spinner.alpha = 1
                })
            }
        }
    }
    
    var noAnswers: Bool?{
        didSet{
            if noAnswers == nil || noAnswers! == false{
                fetchingMore = true
            }
            else{
                label.text = "No one has answered this one yet.\nBe the first to do so."
                spinnerHeightConstraint?.constant = 10
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView?.beginUpdates()
                    self.layoutIfNeeded()
                    self.tableView?.endUpdates()
                    self.spinner.alpha = 0
                }){ _ in
                    self.spinner.stopAnimating()
                }
            }
        }
    }
    
    var errorLoading: Bool?{
        didSet{
            if errorLoading == nil || errorLoading! == false{
                fetchingMore = true
            }
            else{
                label.text = "Error Loading Answers!!\nCheck your Internet Connection and Try Again"
                spinner.isHidden = true
                spinnerHeightConstraint?.constant = 10
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView?.beginUpdates()
                    self.layoutIfNeeded()
                    self.tableView?.endUpdates()
                    self.spinner.alpha = 0
                }){ _ in
                    self.spinner.stopAnimating()
                }
            }
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        setupColors()
    }
    
    func setupUI(){
        backgroundView = UIView()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
    }
    
    var spinnerHeightConstraint: NSLayoutConstraint?
    func setupConstraints(){
        addSubview(backgroundView!)
        addSubview(label)
        addSubview(spinner)
        backgroundView?.fillSuperView()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
            spinner.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ]
        
        constraints.forEach { (constraint) in
            constraint.priority = .defaultHigh
            constraint.isActive = true
        }
        
        spinnerHeightConstraint = spinner.heightAnchor.constraint(equalToConstant: 40)
        spinnerHeightConstraint?.priority = .required
        spinnerHeightConstraint?.isActive = true
    }
    
    func setupColors(){
        label.textColor = selectedTheme.secondaryTextColor
        backgroundView?.backgroundColor = selectedTheme.secondaryPlaceholderColor.withAlphaComponent(0.1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
