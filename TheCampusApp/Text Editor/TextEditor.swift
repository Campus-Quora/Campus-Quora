//
//  ViewController.swift
//  Test Text Editor
//
//  Created by Yogesh Kumar on 30/09/19.
//  Copyright © 2019 Yogesh Kumar. All rights reserved.
//

import UIKit
import WebKit

protocol TextEditorDelegate{
    func textDidChange(_ text: String)
    func heightDidChange(_ height: CGFloat)
}

class TextEditor: UIView, WKScriptMessageHandler{
    var delegate: TextEditorDelegate?
    let placeholderLabel: UILabel = {
        let label = UILabel();
        label.textColor = UIColor.lightGray.withAlphaComponent(0.65)
        label.numberOfLines = 0
        return label
    }()
    
    var font: String?{
        didSet{
            guard let font = font else {return}
            let jsCode = "editor.style.font =  '\(font)'"
            webView.evaluateJavaScript(jsCode, completionHandler: nil)
        }
    }
    
    var fontWeight: String?{
        didSet{
            guard let font = font else {return}
            let jsCode = "editor.style.font =  '\(font)'"
            webView.evaluateJavaScript(jsCode, completionHandler: nil)
        }
    }
    
    var fontSize: Int?{
        didSet{
            guard let fontSize = fontSize else {return}
            let jsCode = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='\(fontSize)%'"
            print(jsCode)
            webView.evaluateJavaScript(jsCode, completionHandler: nil)
        }
    }
    
    // These correspond to name of message recieved from javascript
    static var textDidChange = "textDidChange"
    static var heightDidChange = "heightDidChange"
    static var defaultHeight: CGFloat = 60
    var height: CGFloat = TextEditor.defaultHeight
    
    // This function is called by javascript
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch(message.name){
            case TextEditor.textDidChange:
                guard let text =
                    message.body as? String else {return}
                 placeholderLabel.isHidden = !(text == "" || text == "<br>")
                delegate?.textDidChange(text)
            
            case TextEditor.heightDidChange:
                guard let height = message.body as? CGFloat else {return}
                if(height > self.height){
                    self.height = height
                    delegate?.heightDidChange(height)
                }
            default: break
        }
    }
    
    var webView: WKWebView!
    var padding: CGFloat = 20
    
    // This adds text to editor
    func addText(text: String?){
        guard let text = text else{return}
    
        let jsCode = "editor.innerHTML += '\(text.htmlEscapeQuotes)'"
        webView.evaluateJavaScript(jsCode, completionHandler: nil)
    }
    
    init(padding: CGFloat = 20, customHTML: String? = nil){
        super.init(frame: .zero)
        self.padding = padding
    
        guard let scriptPath = Bundle.main.path(forResource: "TextEditor", ofType: "js"),
        let scriptContent = try? String(contentsOfFile: scriptPath, encoding: .utf8)
        else { fatalError("Unable to find javscript/html for text editor") }
        
        let HTMLResource = customHTML ?? "TextEditor.html"
        guard let htmlPath = Bundle.main.path(forResource: HTMLResource, ofType: "html"),
        let html = try? String(contentsOfFile: htmlPath, encoding: .utf8)
        else{ fatalError("Cannot Read Files") }
        
        // Add Javascript
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.addUserScript(
            WKUserScript(source: scriptContent,
                         injectionTime: .atDocumentEnd,
                         forMainFrameOnly: true
            )
        )
        configuration.userContentController.add(self, name: TextEditor.textDidChange)
        configuration.userContentController.add(self, name: TextEditor.heightDidChange)
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        
        // Load HTML
        webView.loadHTMLString(html, baseURL: nil)
        
        webView.scrollView.bounces = false
        webView.isOpaque = false
        webView.backgroundColor = .clear
        
        // Add Constraints
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding)
        
        addSubview(webView)
        webView.anchor(top: topAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: padding, paddingBottom: padding, paddingLeft: padding, paddingRight: padding)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension String{
    var htmlToPlainText: String {
        return [
            ("(<[^>]*>)|(&\\w+;)", " "),
            ("[ ]+", " ")
            ].reduce(self) {
                try! $0.replacing(pattern: $1.0, with: $1.1)
            }.resolvedHTMLEntities
    }
    
    var resolvedHTMLEntities: String {
        return self
            .replacingOccurrences(of: "&#39;", with: "'")
            .replacingOccurrences(of: "&#x27;", with: "'")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&nbsp;", with: " ")
    }
    
    func replacing(pattern: String, with template: String) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return regex.stringByReplacingMatches(in: self, options: [], range: NSRange(0..<self.utf16.count), withTemplate: template)
    }
    
    var htmlEscapeQuotes: String {
        return [
            ("\"", "\\\""),
            ("“", "&quot;"),
            ("\r", "\\r"),
            ("\n", "\\n")
            ].reduce(self) {
                return $0.replacingOccurrences(of: $1.0, with: $1.1)
        }
    }
}
