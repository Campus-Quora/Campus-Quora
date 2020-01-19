//
//  KeyboardEvents.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 13/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit

extension TextEditorViewController: UITextViewDelegate{
    
    // This is triggered when user presses done on toolbar
    @objc func handleDone(){
        view.endEditing(true)
        reloadInputViews()
    }
    
    // This handles colors of active and non active buttons in toolbar
    @objc func handleButtonColor(_ sender: UIButton){
        sender.tintColor = selectedColor
        for button in toolbar.leftItems{
            if button.tag != sender.tag{
                button.tintColor = unselectedColor
            }
        }
    }
    
    @objc func handleTextOptions(){
        var alpha: CGFloat = 0
        if(textOptionsHidden){
            // Expand
            self.toolbar.leadingConstraint.constant = -leftOffset
            self.textOptionsView.isUserInteractionEnabled = true
            alpha = 1
        }
        else{
            // Collapse
            self.toolbar.leadingConstraint.constant = self.toolbar.edgeInsets?.left ?? 10
            self.textOptionsView.isUserInteractionEnabled = false
            textOptionsButton.tintColor = unselectedColor
        }
        
        UIView.animate(withDuration: 0.25){
            self.toolbar.superview?.layoutIfNeeded()
            self.toolbar.layoutIfNeeded()
            self.textOptionsView.alpha = alpha
        }
        textOptionsHidden = !textOptionsHidden
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        selectedTextView = textView as? PlaceholderTextView
    }
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String)->Bool{
        guard let textView = textView as? PlaceholderTextView else {return true}
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        let deletedText = textView.text(in: textView.toTextRange(NSRange: range))
        let isDeleted = (deletedText!.count != 0)
        handlePlaceholder(textView, length: newLength)
        return textOptionsView.changeText(textView, text, deletedText, isDeleted)
    }
    
    // Manage placeholders showing and hiding
    func handlePlaceholder(_ textView: PlaceholderTextView, length: Int? = nil){
        // Hide Placeholder
        if let length = length, length > 0{
            if(!textView.placeholderLabel.isHidden){
                textView.placeholderLabel.isHidden = true
                textView.textContainerInset.bottom -= 24
            }
        }
            
        // Show Placeholder
        else{
            if(textView.placeholderLabel.isHidden){
                textView.placeholderLabel.isHidden = false
                textView.textContainerInset.bottom += 24
            }
        }
    }
    
    func handlePlaceholder(_ textView: PlaceholderTextView, shouldHide: Bool){
        // Hide
        if shouldHide{
            if(!textView.placeholderLabel.isHidden){
                textView.placeholderLabel.isHidden = true
                textView.textContainerInset.bottom -= 24
            }
        }
            
        // Show Placeholder
        else{
            if(textView.placeholderLabel.isHidden){
                textView.placeholderLabel.isHidden = false
                textView.textContainerInset.bottom += 24
            }
        }
    }
}
