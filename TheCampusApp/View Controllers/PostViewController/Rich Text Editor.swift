//
//  Rich Text Editor.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 05/10/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

// MARK:- Placeholder UITextView
class PlaceholderTextView: UITextView{
    var placeholderLabel = UILabel()
    var attributedPlaceholder: NSAttributedString?{
        didSet{
            placeholderLabel.numberOfLines = 0
            placeholderLabel.attributedText = attributedPlaceholder
            self.addSubview(placeholderLabel)
            placeholderLabel.anchor(top: self.topAnchor, left: self.leadingAnchor, paddingTop: 8, paddingLeft: 5)
        }
    }
    func constrainRight(to view: UIView){
        placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5).isActive = true
    }
}

// MARK:- PostViewController Extension #4
// Text Editor
extension PostViewController: UITextViewDelegate{
    
    // Manage placeholders showing and hiding
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String)->Bool{
        guard let textView = textView as? PlaceholderTextView else {return true}
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0{
            if(!textView.placeholderLabel.isHidden){
                textView.placeholderLabel.isHidden = true
                textView.textContainerInset.bottom -= 24
            }
        }
        else{
            if(textView.placeholderLabel.isHidden){
                textView.placeholderLabel.isHidden = false
                textView.textContainerInset.bottom += 24
            }
        }
        return true
    }
}

