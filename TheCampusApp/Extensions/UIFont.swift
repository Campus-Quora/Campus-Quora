//
//  UIFont.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 05/10/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
    
    func bold() -> UIFont {
        var symTraits = fontDescriptor.symbolicTraits
        if(isBold){
            symTraits.remove([.traitBold])
        }
        else{
            symTraits.insert([.traitBold])
        }
        let descripter = fontDescriptor.withSymbolicTraits(symTraits)
        return UIFont(descriptor: descripter!, size: 0)
    }
    
    func italic() -> UIFont {
        var symTraits = fontDescriptor.symbolicTraits
        if(isItalic){
            symTraits.remove([.traitItalic])
        }
        else{
            symTraits.insert([.traitItalic])
        }
        let descripter = fontDescriptor.withSymbolicTraits(symTraits)
        return UIFont(descriptor: descripter!, size: 0)
    }
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
}

// Usage:-
// font.bold() will toggle the bold attribute of font maintaining its size
// similary font.italic()
