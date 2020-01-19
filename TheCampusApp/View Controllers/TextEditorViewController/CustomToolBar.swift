//
//  CustomToolBar.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 29/09/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

// MARK:- ToolBarButton
class ToolBarButton: UIButton{
    init(imageName: String) {
        super.init(frame: .zero)
        let size = CGSize(width: 24, height: 24)
        let image = UIImage(named: imageName)?.resizeImage(size: size).withRenderingMode(.alwaysTemplate)
        self.setImage(image, for: .normal)
        self.imageView?.contentMode = .top
        tintColor = selectedTheme.primaryTextColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- Custom ToolBar
class CustomToolBar: UIView{
    
    override var intrinsicContentSize: CGSize{
        return CGSize.zero
    }
    
    var leftItems = [UIButton]()
    var rightItems = [UIButton]()
    var edgeInsets: UIEdgeInsets?
    var toolSpacing: CGFloat?
    var bottomConstraint: NSLayoutConstraint! = nil
    var leadingConstraint: NSLayoutConstraint! = nil
    var backgroundView = UIView()
    
    var topBorder : UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    func layout(){
        // Layout Left Items
        self.backgroundColor = .clear
        addSubview(backgroundView)
        backgroundView.anchor(top: topAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 10)
        
        var leftConstraint: NSLayoutXAxisAnchor
        if #available(iOS 11.0, *) {
            leftConstraint = self.safeAreaLayoutGuide.leadingAnchor
        } else {
            leftConstraint = self.leadingAnchor
        }
        var leftSpacing = self.edgeInsets?.left ?? 0
        for tool in leftItems{
            addSubview(tool)
            tool.anchor(top: backgroundView.topAnchor, bottom: bottomAnchor, paddingTop: edgeInsets?.top, paddingBottom: edgeInsets?.bottom)
            let toolLeftConstraint = tool.leadingAnchor.constraint(equalTo: leftConstraint, constant: leftSpacing)
            toolLeftConstraint.isActive = true
            if(leadingConstraint == nil){
                leadingConstraint = toolLeftConstraint
            }
            leftConstraint = tool.trailingAnchor
            leftSpacing = toolSpacing ?? 0
        }
        
        // Layout Right Items
        var rightConstraint: NSLayoutXAxisAnchor
        if #available(iOS 11.0, *) {
            rightConstraint = self.safeAreaLayoutGuide.trailingAnchor
        } else {
            rightConstraint = self.trailingAnchor
        }
        var rightSpacing = self.edgeInsets?.right
        for tool in rightItems{
            addSubview(tool)
            tool.anchor(top: backgroundView.topAnchor, bottom: bottomAnchor, right: rightConstraint, paddingTop: edgeInsets?.top, paddingBottom: edgeInsets?.bottom, paddingRight: rightSpacing)
            rightConstraint = tool.leadingAnchor
            rightSpacing = toolSpacing
        }
        
        // Top Border
        addSubview(topBorder)
        topBorder.anchor(top: backgroundView.topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 1)
    }
}

// MARK:- Text Format Options
class TextFormatOptionsView: UIView, UITextViewDelegate{
    // MARK:- Button Types
    enum ButtonType: String{
        case bold = "Bold"
        case italics = "Italics"
        case underlined = "Underlined"
        case unorderedList = "UnorderedList"
        case orderedList = "OrderedList"
    }
    
    // MARK:- Data Members
    var itemPadding: CGFloat = 10
    let baseFontSize: CGFloat = 16
    var unselectedColor: UIColor! = nil
    
    lazy var font = UIFont.systemFont(ofSize: baseFontSize)
    lazy var currentFont = font
    
    lazy var bulletString = NSAttributedString(string: "\u{2022} ", attributes: [.font: currentFont])
    lazy var spaceBulletString = NSAttributedString(string: "\n\u{2022} ", attributes: [.font: currentFont])
    
    static let backwardDirection = UITextDirection(rawValue: UITextStorageDirection.backward.rawValue)
    lazy var bulletPointParagraphStyle: NSMutableParagraphStyle = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.headIndent = NSString(string: "\u{2022}").size(withAttributes: [.font: currentFont]).width
        return paragraph
    }()
    
    var isUnderlined = false
    var isUnorderedListActive = false{
        didSet{
            if(oldValue == isUnorderedListActive){ return }
            unorderedListButton.tintColor = isUnorderedListActive ? selectedAccentColor.primaryColor: selectedTheme.primaryTextColor
        }
    }
    var isOrderedListActive = false{
        didSet{
            if(oldValue == isOrderedListActive){ return }
            orderedListButton.tintColor = isOrderedListActive ? selectedAccentColor.primaryColor: selectedTheme.primaryTextColor
            orderedListItemNumber = 0
        }
    }
    var orderedListItemNumber = 0
    
    var dataSource: UITextView?
    
    // MARK:- UI Elements
    let boldButton = ToolBarButton(imageName: ButtonType.bold.rawValue)
    let italicsButton = ToolBarButton(imageName: ButtonType.italics.rawValue)
    let underlinedButton = ToolBarButton(imageName: ButtonType.underlined.rawValue)
    let orderedListButton = ToolBarButton(imageName: ButtonType.orderedList.rawValue)
    let unorderedListButton = ToolBarButton(imageName: ButtonType.unorderedList.rawValue)
    
    // MARK:- Setup Mehods
    func initialise(_ unselectedColor: UIColor){
        layout()
        setupActions()
        setupColors(unselectedColor)
    }
    
    func layout(){
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        
        let stackView = UIStackView(arrangedSubviews: [boldButton, italicsButton, underlinedButton, orderedListButton, unorderedListButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        let numberOfItems = stackView.arrangedSubviews.count
        let stackWidth: CGFloat = CGFloat((numberOfItems * 30)) + CGFloat(numberOfItems + 1) * itemPadding
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.anchor(top: topAnchor, left: leadingAnchor)
        scrollView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        scrollView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
        
        stackView.anchor(top: scrollView.topAnchor, bottom: bottomAnchor, left: scrollView.leadingAnchor, right: scrollView.trailingAnchor, width: stackWidth)
    }
    
    func setupActions(){
        boldButton.addTarget(self, action: #selector(handleBold), for: .touchUpInside)
        italicsButton.addTarget(self, action: #selector(handleItalics), for: .touchUpInside)
        underlinedButton.addTarget(self, action: #selector(handleUnderlined), for: .touchUpInside)
        orderedListButton.addTarget(self, action: #selector(handleOrderedList), for: .touchUpInside)
        unorderedListButton.addTarget(self, action: #selector(handleUnorderedList), for: .touchUpInside)
    }
    
    func setupColors(_ color: UIColor){
        self.unselectedColor = color
        [boldButton,italicsButton,underlinedButton,orderedListButton,unorderedListButton].forEach { (button) in
            button.tintColor = color
        }
    }
    
    // MARK:- Button Handlers
    @objc func handleBold(){
        guard let textView = dataSource else {return}
        let range = textView.selectedRange
        if(range.length == 0){
            currentFont = currentFont.bold()
            textView.typingAttributes[.font] = currentFont
            return
        }
        textView.attributedText.enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { (attributes, range, stop) in
            if let font = attributes[.font] as? UIFont{
                textView.textStorage.addAttributes([NSAttributedString.Key.font: font.bold()], range: range)
            }
        }
    }
    @objc func handleItalics(){
        guard let textView = dataSource else {return}
        let range = textView.selectedRange
        if(range.length == 0){
            currentFont = currentFont.italic()
            textView.typingAttributes[.font] = currentFont
            return
        }
        textView.attributedText.enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { (attributes, range, stop) in
            if let font = attributes[.font] as? UIFont{
                textView.textStorage.addAttributes([NSAttributedString.Key.font: font.italic()], range: range)
            }
        }
    }
    @objc func handleUnderlined(){
        guard let textView = dataSource else {return}
        let range = textView.selectedRange
        if(range.length == 0){
            if(isUnderlined){
                textView.typingAttributes.removeValue(forKey: .underlineStyle)
            }
            else{
                textView.typingAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
            }
            isUnderlined = !isUnderlined
            return
        }
        textView.attributedText.enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { (attributes, range, stop) in
            if let _ = attributes[.underlineStyle] as? NSUnderlineStyle.RawValue{
                textView.textStorage.removeAttribute(.underlineStyle, range: range)
            }
            else{
                textView.textStorage.addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue], range: range)
            }
        }
    }
    
    @objc func handleOrderedList(){
        isOrderedListActive = !isOrderedListActive
        if(!isOrderedListActive){
            removeOrderedList()
            return
        }
        if(isUnorderedListActive){
            isUnorderedListActive = false
            removeUnorderedList()
        }
        orderedListHelper()
    }
    func orderedListHelper(){
        guard let textView = dataSource else {return}
        let currentPosition = textView.selectedTextRange
        
        let startOfLine = textView.tokenizer.position(from: currentPosition!.start, toBoundary: .line, inDirection: TextFormatOptionsView.backwardDirection)
        if let startOfLine = startOfLine{
            var location = textView.offset(from: textView.beginningOfDocument, to: startOfLine)
            var range = NSRange(location: location, length: 0)
            orderedListItemNumber += 1
            var length = 3
            if(orderedListItemNumber > 9){length += 1}
            if(orderedListItemNumber > 99){length += 1}
            if(orderedListItemNumber > 999){length += 1}
            
            if(location > 0){
                var prevCharRange = NSRange(location: location, length: 1)
                var prevTextRange = textView.toTextRange(NSRange: prevCharRange)
                var character = textView.text(in: prevTextRange)
                if(character == "\n"){
                    let number = NSAttributedString(string: "\n\(orderedListItemNumber). ", attributes: [.font: currentFont])
                    textView.textStorage.replaceCharacters(in: prevCharRange , with: number)
                    textView.offsetSelection(by: length)
                    return
                }
                else{
                    prevCharRange = NSRange(location: location - 1, length: 1)
                    prevTextRange = textView.toTextRange(NSRange: prevCharRange)
                    character = textView.text(in: prevTextRange)
                    if(character != "\n"){
                        // Fixes text wrapping issue
                        let startOfLine = textView.tokenizer.position(from: currentPosition!.start, toBoundary: .paragraph, inDirection: TextFormatOptionsView.backwardDirection)
                        if let startOfLine = startOfLine{
                            location = textView.offset(from: textView.beginningOfDocument, to: startOfLine)
                            range = NSRange(location: location, length: 0)
                        }
                    }
                }
            }
            let number = NSAttributedString(string: "\(orderedListItemNumber). ", attributes: [.font: currentFont])
            textView.textStorage.replaceCharacters(in: range , with: number)
            textView.offsetSelection(by: length)
        }
    }
    func removeOrderedList(){
        guard let textView = dataSource else {return}
        let currentPosition = textView.selectedTextRange
        
        let startOfLine = textView.tokenizer.position(from: currentPosition!.start, toBoundary: .paragraph, inDirection: TextFormatOptionsView.backwardDirection)
        if let startOfLine = startOfLine{
            let location = textView.offset(from: textView.beginningOfDocument, to: startOfLine)
            var length = 3
            if(orderedListItemNumber > 9){length += 1}
            if(orderedListItemNumber > 99){length += 1}
            if(orderedListItemNumber > 999){length += 1}
            let range = NSRange(location: location, length: length)
            let empty = NSAttributedString(string: "")
            let currentLoc = textView.selectedRange.location
            if(currentLoc < length){
                length = currentLoc
            }
            else if(currentLoc + length > textView.textStorage.length){
                length = textView.textStorage.length - textView.selectedRange.location
            }
            textView.textStorage.replaceCharacters(in: range , with: empty)
            textView.offsetSelection(by: -length)
        }
    }
    
    @objc func handleUnorderedList(){
        isUnorderedListActive = !isUnorderedListActive
        if(!isUnorderedListActive){
            removeUnorderedList()
            return
        }
        if(isOrderedListActive){
            isOrderedListActive = false
            removeOrderedList()
        }
        unorderedListHelper()
    }
    func unorderedListHelper(){
        guard let textView = dataSource else {return}
        let currentPosition = textView.selectedTextRange
        let startOfLine = textView.tokenizer.position(from: currentPosition!.start, toBoundary: .line, inDirection: TextFormatOptionsView.backwardDirection)
        if let startOfLine = startOfLine{
            var location = textView.offset(from: textView.beginningOfDocument, to: startOfLine)
            var range = NSRange(location: location, length: 0)
            if(location > 0){
                var prevCharRange = NSRange(location: location, length: 1)
                var prevTextRange = textView.toTextRange(NSRange: prevCharRange)
                let character = textView.text(in: prevTextRange)
                if(character == "\n"){
                    textView.textStorage.replaceCharacters(in: prevCharRange, with: spaceBulletString)
                    textView.offsetSelection(by: 2)
                    return
                }
                else{
                    prevCharRange = NSRange(location: location - 1, length: 1)
                    prevTextRange = textView.toTextRange(NSRange: prevCharRange)
                    let character = textView.text(in: prevTextRange)
                    if(character != "\n"){
                        // Fixes text wrapping issue
                        let startOfLine = textView.tokenizer.position(from: currentPosition!.start, toBoundary: .paragraph, inDirection: TextFormatOptionsView.backwardDirection)
                        if let startOfLine = startOfLine{
                            location = textView.offset(from: textView.beginningOfDocument, to: startOfLine)
                            range = NSRange(location: location, length: 0)
                        }
                    }
                }
            }
            textView.textStorage.replaceCharacters(in: range , with: bulletString)
            textView.offsetSelection(by: 2)
        }
    }
    func removeUnorderedList(){
        guard let textView = dataSource else {return}
        let currentPosition = textView.selectedTextRange
        
        let startOfLine = textView.tokenizer.position(from: currentPosition!.start, toBoundary: .paragraph, inDirection: TextFormatOptionsView.backwardDirection)
        if let startOfLine = startOfLine{
            let location = textView.offset(from: textView.beginningOfDocument, to: startOfLine)
            var length = 2
            let range = NSRange(location: location, length: length)
            let empty = NSAttributedString(string: "")
            let currentLoc = textView.selectedRange.location
            if(currentLoc < length){
                length = currentLoc
            }
            else if(currentLoc + length > textView.textStorage.length){
                length = textView.textStorage.length - textView.selectedRange.location
            }
            textView.textStorage.replaceCharacters(in: range , with: empty)
            textView.offsetSelection(by: -length)
        }
    }
    
    
//    func increaseBulletLevel(_ level: Int){
//        guard let textView = dataSource else {return}
//        let currentPosition = textView.selectedTextRange!.start
//        let textDirection = UITextDirection(rawValue: UITextStorageDirection.backward.rawValue)
//        let startOfLine = textView.tokenizer.position(from: currentPosition, toBoundary: .paragraph, inDirection: textDirection)!
//        let location = textView.offset(from: textView.beginningOfDocument, to: startOfLine) + (level - 1)*4
//        let length = 2
//        let range = NSRange(location: location, length: length)
//        textView.textStorage.deleteCharacters(in: range)
//    }
    
    
    // Delegate Functions
    func textViewDidChange(_ textView: UITextView){}
    
    func changeText(_ textView: UITextView, _ text: String, _ deletedText: String?, _ isDeleted: Bool)->Bool{
        if(!isDeleted && isUnorderedListActive && text == "\n"){
            textView.textStorage.insert(spaceBulletString, at: textView.selectedRange.location)
            textView.offsetSelection(by: 3)
            return false
        }
        if(!isDeleted && isOrderedListActive && text == "\n"){
            orderedListItemNumber += 1
            let number = NSAttributedString(string: "\n\(orderedListItemNumber). ", attributes: [.font: currentFont])
            textView.textStorage.insert(number, at: textView.selectedRange.location)
            textView.offsetSelection(by: 4)
            return false
        }
        else if(isDeleted && deletedText! == "\u{2022}"){
            isUnorderedListActive = false
        }
        return true
    }
}

extension UITextView{
    func offsetSelection(by offset: Int){
        if let range = selectedTextRange{
            let newStart = position(from: range.start, offset: offset)!
            let newEnd = position(from: range.end, offset: offset)!
            self.selectedTextRange = textRange(from: newStart, to: newEnd)
        }
    }
    
    func toTextRange(NSRange range: NSRange)->UITextRange{
        let newStart = position(from: beginningOfDocument, offset: range.location)!
        let newEnd = position(from: newStart, offset: range.length)!
        return textRange(from: newStart, to: newEnd)!
    }
}

// Issues:-

// Additional Required Functionality:-
// 1. Set the tintcolor of button based on attributes of text. Eg:- make tint blue when text is bold
// 2. Add 3 levels of heading

// Optional Features
// 1. Add quote
// 2. Add code
