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
    func textDidChange(_ text: inout String, for editor: TextEditor)
    func heightDidChange(_ height: CGFloat, for editor: TextEditor)
}

class TextEditor: UIView, WKScriptMessageHandler, UIScrollViewDelegate{
    static let defaultHeight: CGFloat = 100
    static var textDidChange = "textDidChange"
    static var heightDidChange = "heightDidChange"
    var heightConstraint: NSLayoutConstraint?
    var delegate: TextEditorDelegate?
    var height: CGFloat = TextEditor.defaultHeight
    var webView: WKWebView!
    var padding: CGFloat = 20
    var scripts = [String]()
    
    let placeholderLabel: UILabel = {
        let label = UILabel();
        label.textColor = UIColor.lightGray.withAlphaComponent(0.65)
        label.numberOfLines = 0
        return label
    }()
    
    init(padding: CGFloat = 20, customHTML: String? = nil){
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: TextEditor.defaultHeight))
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
        
        webView.navigationDelegate = self as? WKNavigationDelegate
        webView.scrollView.bounces = false
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.delegate = self
        webView.isOpaque = false
        webView.backgroundColor = .clear
        
        // Add Constraints
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: padding, paddingLeft: padding, paddingRight: padding)
        
        addSubview(webView)
        webView.anchor(top: topAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor, paddingTop: padding, paddingBottom: padding, paddingLeft: padding, paddingRight: padding)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = self.heightAnchor.constraint(equalToConstant: TextEditor.defaultHeight)
        heightConstraint?.isActive = true
    }
    
    
    // This function is called by javascript
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch(message.name){
            case TextEditor.textDidChange:
                guard var text =
                    message.body as? String else {return}
                 placeholderLabel.isHidden = !(text == "" || text == "<br>")
                delegate?.textDidChange(&text, for: self)
            
            case TextEditor.heightDidChange:
                guard let height = message.body as? CGFloat else { return }
                if(self.height < height + 30){
                    self.height += 30
                    heightConstraint?.constant = self.height
                    delegate?.heightDidChange(self.height, for: self)
                }
            
            default: break
        }
    }
    
    // This adds text to editor
    func addText(text: String?){
        guard let text = text else{return}
        let jsCode = "editor.innerHTML += '\(text.htmlEscapeQuotes)'"
        
        if webView.isLoading {
            scripts.append(jsCode)
        } else {
            webView.evaluateJavaScript(jsCode, completionHandler: { (id, error) in
                print(error ?? "ERRor")
            })
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        for script in scripts{
            self.webView.evaluateJavaScript(script) { (id, error) in
                print(error ?? "ERRor")
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
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
