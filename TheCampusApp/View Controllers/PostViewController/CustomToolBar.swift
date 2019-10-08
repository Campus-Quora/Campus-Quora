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
        let size = CGSize(width: 30, height: 30)
        let image = UIImage(named: imageName)?.resizeImage(size: size).withRenderingMode(.alwaysTemplate)
        self.setImage(image, for: .normal)
        tintColor = unselectedColor
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
    
    var topBorder : UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    func layout(){
        // Layout Left Items
        var leftConstraint = self.leadingAnchor
        var leftSpacing = self.edgeInsets?.left
        for tool in leftItems{
            addSubview(tool)
            if #available(iOS 11.0, *) {
                tool.anchor(top: topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, left: leftConstraint, paddingTop: edgeInsets?.top, paddingBottom: edgeInsets?.bottom, paddingLeft: leftSpacing)
            } else {
                tool.anchor(top: topAnchor, bottom: bottomAnchor, left: leftConstraint, paddingTop: edgeInsets?.top, paddingBottom: edgeInsets?.bottom, paddingLeft: leftSpacing)
            }
            leftConstraint = tool.trailingAnchor
            leftSpacing = toolSpacing
        }
        
        // Layout Right Items
        var rightConstraint = self.trailingAnchor
        var rightSpacing = self.edgeInsets?.right
        for tool in rightItems{
            addSubview(tool)
            if #available(iOS 11.0, *) {
                tool.anchor(top: topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightConstraint, paddingTop: edgeInsets?.top, paddingBottom: edgeInsets?.bottom, paddingRight: rightSpacing)
            } else {
                tool.anchor(top: topAnchor, bottom: bottomAnchor, right: rightConstraint, paddingTop: edgeInsets?.top, paddingBottom: edgeInsets?.bottom, paddingRight: rightSpacing)
            }
            rightConstraint = tool.leadingAnchor
            rightSpacing = toolSpacing
        }
        
        // Top Border
        addSubview(topBorder)
        topBorder.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 1)
    }
}

protocol TextFormatOptionsViewDelegate{
    func textViewDidChange(_ textView: UITextView)
}

extension TextFormatOptionsViewDelegate{
    func textViewDidChange(_ textView: UITextView){}
}

// MARK:- Text Format Options
class TextFormatOptionsView: UIView, UITextViewDelegate{
    enum ButtonType: String{
        case bold = "Bold"
        case italics = "Italics"
        case underlined = "Underlined"
        case unorderedList = "UnorderedList"
        case orderedList = "OrderedList"
    }
    
    let baseFontSize: CGFloat = 16
    lazy var font = UIFont.systemFont(ofSize: baseFontSize)
    lazy var currentFont = font
    lazy var bulletString = NSAttributedString(string: "\u{2022} ", attributes: [.font: currentFont])
    var isUnderlined = false
    
    var dataSource: UITextView?{
        didSet{
            dataSource?.delegate = self
        }
    }
    
    var delegate: TextFormatOptionsViewDelegate?
    
    let boldButton = ToolBarButton(imageName: ButtonType.bold.rawValue)
    let italicsButton = ToolBarButton(imageName: ButtonType.italics.rawValue)
    let underlinedButton = ToolBarButton(imageName: ButtonType.underlined.rawValue)
    let orderedListButton = ToolBarButton(imageName: ButtonType.orderedList.rawValue)
    let unorderedListButton = ToolBarButton(imageName: ButtonType.unorderedList.rawValue)
    
    func initialise(){
        layout()
        setupActions()
    }
    
    func layout(){
        let stackView = UIStackView(arrangedSubviews: [boldButton, italicsButton, underlinedButton, orderedListButton, unorderedListButton])
        addSubview(stackView)
        stackView.fillSuperView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
    }
    
    func setupActions(){
        boldButton.addTarget(self, action: #selector(handleBold), for: .touchUpInside)
        italicsButton.addTarget(self, action: #selector(handleItalics), for: .touchUpInside)
        underlinedButton.addTarget(self, action: #selector(handleUnderlined), for: .touchUpInside)
        orderedListButton.addTarget(self, action: #selector(handleOrderedList), for: .touchUpInside)
        unorderedListButton.addTarget(self, action: #selector(handleUnorderedList), for: .touchUpInside)
    }
    
    @objc func handleBold(){
        guard let textView = dataSource else {return}
        let range = textView.selectedRange
        if(range.length == 0){
            currentFont = currentFont.bold()
            textView.typingAttributes[.font] = currentFont
            return
        }
        textView.attributedText.enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { (attributes, range, stop) in
            print("YES")
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
        
    }
    
    var isBulletPointActive: Bool = false
    @objc func handleUnorderedList(){
        isBulletPointActive = !isBulletPointActive
        if(!isBulletPointActive){return}
        convertToBulletPoint()
    }
    
    static let backwardDirection = UITextDirection(rawValue: UITextStorageDirection.backward.rawValue)
    lazy var bulletPointParagraphStyle: NSMutableParagraphStyle = {
       let paragraph = NSMutableParagraphStyle()
        paragraph.headIndent = NSString(string: "\u{2022}").size(withAttributes: [.font: currentFont]).width
        return paragraph
    }()
    
    func convertToBulletPoint(){
        guard let textView = dataSource else {return}
        let currentPosition = textView.selectedTextRange
        
        let startOfLine = textView.tokenizer.position(from: currentPosition!.start, toBoundary: .line, inDirection: TextFormatOptionsView.backwardDirection)
        if let startOfLine = startOfLine{
            let location = textView.offset(from: textView.beginningOfDocument, to: startOfLine)
            let range = NSRange(location: location, length: 0)
            textView.textStorage.replaceCharacters(in: range , with: bulletString)
            textView.offsetSelection(by: 2)
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
    
    var lastNewLineLocation: NSRange?
    var lastLength: Int = 0
    var lastCharacter: NSAttributedString?
    
    func textViewDidChange(_ textView: UITextView) {
        var range = textView.selectedRange
        range.length = 1
        range.location -= 1
        if(range.location < 0){
            lastCharacter = nil
            lastLength = 0
            lastNewLineLocation = nil
            return
        }
        lastCharacter = textView.textStorage.attributedSubstring(from: range)
        if let lastCharacter = lastCharacter{
            if(isBulletPointActive && lastCharacter.string == "\n"){
                textView.textStorage.insert(bulletString, at: range.location + 1)
                textView.typingAttributes[.paragraphStyle] = self.bulletPointParagraphStyle
                textView.offsetSelection(by: 2)
            }
        }
        lastLength = textView.textStorage.length
    }
}

extension UITextView{
    func offsetSelection(by offset: Int){
        if let range = selectedTextRange{
            let newStart = position(from: range.start, offset: 2)!
            let newEnd = position(from: range.end, offset: 2)!
            self.selectedTextRange = textRange(from: newStart, to: newEnd)
        }
    }
}

// Issues:-

// Additional Required Functionality:-
// 1. Set the tintcolor of button based on attributes of text. Eg:- make tint blue when text is bold
// 2. Add unordered list
// 3. Add ordered list
// 4. Add 3 levels of heading

// Optional Features
// 1. Add quote
// 2. Add code

// UNUSED CODE

//class ExtraTextOptionsView: UIView{
//    let unOrderedListButton : ExtraTextOptionsButton = {
//        let button = ExtraTextOptionsButton(text: "Unordered List", imageName: "UnorderedList")
//        return button
//    }()
//
//    let orderedListButton : ExtraTextOptionsButton = {
//        let button = ExtraTextOptionsButton(text: "Ordered List", imageName: "UnorderedList")
//        return button
//    }()
//
//    let quoteButton : ExtraTextOptionsButton = {
//        let button = ExtraTextOptionsButton(text: "Quote", imageName: "Quote")
//        return button
//    }()
//
//    let codeButton : ExtraTextOptionsButton = {
//        let button = ExtraTextOptionsButton(text: "Code", imageName: "CurlyBraces")
//        return button
//    }()
//
//    let mathButton : ExtraTextOptionsButton = {
//        let button = ExtraTextOptionsButton(text: "Math", imageName: "Sigma")
//        return button
//    }()
//
//    let background = UIView()
//
//
//    init(padding: CGFloat){
//        super.init(frame: .zero)
//
//        let stack = UIStackView(arrangedSubviews: [unOrderedListButton, orderedListButton, quoteButton, codeButton, mathButton])
//        stack.axis = .vertical
//        stack.distribution = .fillEqually
//        addSubview(background)
//        background.addSubview(stack)
//        backgroundColor = .white
//
//        for item in stack.arrangedSubviews{
//            item.anchor(left: stack.leadingAnchor, right: stack.trailingAnchor, paddingLeft: 0, paddingRight: 0)
//        }
//
//        background.backgroundColor = UIColor(white: 0.83, alpha: 1)
//
//        // Constraints
//        stack.anchor(top: background.topAnchor, bottom: background.bottomAnchor, left: background.leadingAnchor, right: background.trailingAnchor)
//        background.anchor(top: topAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: padding, paddingBottom: padding, paddingLeft: padding, paddingRight: padding)
//    }
//
//    override func didMoveToWindow() {
//        super.didMoveToWindow()
//        if #available(iOS 11.0, *) {
//            //            if let window = self.window {
//            //                self.translatesAutoresizingMaskIntoConstraints = false
//            //                self.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
//            //                self.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor)
//            //            }
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}


//class ExtraTextOptionsButton: UIButton{
//    init(text: String imageName: String) {
//        super.init(frame: .zero)
//        let size = CGSize(width: 30, height: 30)
//        let image = UIImage(named: imageName)?.resizeImage(size: size).withRenderingMode(.alwaysTemplate)
//        self.setImage(image, for: .normal)
//        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
//        self.contentHorizontalAlignment = .left
//        self.setTitle(text, for: .normal)
//        self.setColor(unselectedColor)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setColor(_ color: UIColor){
//        self.tintColor = color
//        self.setTitleColor(color, for: .normal)
//    }
//}
