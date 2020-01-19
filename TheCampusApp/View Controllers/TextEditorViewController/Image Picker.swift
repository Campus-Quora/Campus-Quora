//
//  Image Picker.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 09/10/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import Photos

extension TextEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // This is event handler for pressing image selection button on toolbar
    @objc func handleImageSelection(){
        // ======= CheckPermisson =======
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            showImagePicker()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ newStatus in
                if newStatus == PHAuthorizationStatus.authorized {
                    DispatchQueue.main.async {
                        self.showImagePicker()
                    }
                }
            })
        case .restricted:
            print("User do not have access to photo album.")
        case .denied:
            print("User has denied the permission.")
        @unknown default: break
        }
    }

    // This Displays Image Picker View
    func showImagePicker(){
        self.view.endEditing(true)
        addChild(imagePickerVC)
        view.addSubview(imagePickerVC.view)
        imagePickerVC.didMove(toParent: self)
        imagePickerVC.view.frame = view.bounds.offsetBy(dx: 0, dy: UIScreen.main.bounds.size.height)
        let finalFrame = self.view.bounds
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveLinear, animations: {
            self.imagePickerVC.view.frame = finalFrame
            self.toolbar.alpha = 0
            self.toolbar.superview?.layoutIfNeeded()
        }, completion: { _ in
            self.toolbar.isHidden = true
            self.toolbar.isUserInteractionEnabled = false
        })
    }
    
    // This Dismisses Image Picker View
    func dismissImagePicker(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let finalFrame = view.bounds.offsetBy(dx: 0, dy: UIScreen.main.bounds.size.height)
        self.toolbar.isHidden = false
        self.toolbar.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveLinear, animations: {
            self.imagePickerVC.view.frame = finalFrame
            self.toolbar.superview?.layoutIfNeeded()
            self.toolbar.alpha = 1
        }, completion: { _ in
            self.imagePickerVC.willMove(toParent: nil)
            self.imagePickerVC.view.removeFromSuperview()
            self.imagePickerVC.removeFromParent()
            self.becomeFirstResponder()
        })
    }

    
    // This is called when user ends up selecting an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage,
            let selectedTextView = self.selectedTextView,
            let scaledImage = image.resized(toWidth: selectedTextView.frame.size.width - 10),
            let encodedString = scaledImage.jpegData(compressionQuality: 0.5)?.base64EncodedString(),
            let attributedString = NSAttributedString(base64EndodedImageString: encodedString)
        else {return}

        selectedTextView.textStorage.insert(attributedString, at: selectedTextView.selectedRange.location)
        selectedTextView.textStorage.insert(NSAttributedString(string: "\n\n"), at: selectedTextView.selectedRange.location + 1)
        handlePlaceholder(selectedTextView, shouldHide: true)
        dismissImagePicker()
    }
    
    // This is called when user presses cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismissImagePicker()
    }
}


