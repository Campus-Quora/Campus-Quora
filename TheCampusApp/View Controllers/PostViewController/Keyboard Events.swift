//
//  Keyboard Events.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 05/10/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

// MARK:- PostViewController Extension #2
// Keyboard Events
extension PostViewController{
    @objc func handleKeyboardNotification(notification: NSNotification) {
        let isKeyboardVisible = notification.name == UIResponder.keyboardWillShowNotification
        if(isKeyboardVisible){
            adjustInsetForKeyboardShow(notification)
        }
        else{
            adjustInsetForKeyboardHide(notification)
        }
    }
    
    func adjustInsetForKeyboardShow(_ notification: NSNotification){
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            else {return}
        
        var focusedControl: UITextView!
        
        if(questionHeading.isFirstResponder){ focusedControl =  questionHeading}
        else{focusedControl = questionDescription}
        
        let keyboardFrameInView: CGRect = self.view.convert(keyboardFrame, from: nil)
        let scrollViewKeyboardIntersection: CGRect = scrollView.frame.intersection(keyboardFrameInView)
        
        // This is the frame visible on screen before keyboard
        let controlFrameInScrollView = scrollView.convert(focusedControl.bounds, from: focusedControl)
        
        // This is the top of selected textView in frame before keyboard
        let controlVisualOffsetToTopOfScrollview = controlFrameInScrollView.origin.y - scrollView.contentOffset.y
        
        // This is the distance from top of textView to the selection point
        var height = focusedControl.selectionRects(for: focusedControl.selectedTextRange!)[0].rect.origin.y
        
        // Bug Fix: height becomes infinite when selection is in last line
        height = height.isInfinite ? focusedControl.frame.size.height: height
        
        // This is the final position we need to be
        let controlVisualBottom = controlVisualOffsetToTopOfScrollview + height + 30
        
        // This is the visible height of scroll view after keyboard appears
        let scrollViewVisibleHeight = scrollView.frame.size.height - scrollViewKeyboardIntersection.size.height;
        var newContentOffset = scrollView.contentOffset;
        if(controlVisualBottom > scrollViewVisibleHeight){
            newContentOffset.y += (controlVisualBottom - scrollViewVisibleHeight);
            
            // Only Scroll when keyboard hides content
            if(newContentOffset.y <= scrollView.contentSize.height - scrollViewVisibleHeight){
                let options = UIView.AnimationOptions(rawValue: animationCurve.uintValue)
                UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                    self.scrollView.contentInset.bottom = scrollViewKeyboardIntersection.size.height
                    self.scrollView.scrollIndicatorInsets.bottom = scrollViewKeyboardIntersection.size.height
                    self.scrollView.setContentOffset(newContentOffset, animated: false)
                }, completion: nil)
            }
        }
    }
    
    func adjustInsetForKeyboardHide(_ notification: NSNotification) {
        if(!self.isViewLoaded || (self.view?.window == nil)){return}
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            else {return}
        
        let options = UIView.AnimationOptions(rawValue: animationCurve.uintValue)
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.scrollView.contentInset = .zero;
            self.scrollView.scrollIndicatorInsets = .zero;
        }, completion: nil)
    }
    
    // TODO:- Move scrollView up when user input flows to next line and it goes below keyboard
    func adjustOffsetWithUserInput(keyboardHeight: CGFloat){
        
    }
}
