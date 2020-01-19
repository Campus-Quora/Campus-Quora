//
//  NSAttributedString.swift
//  TheCampusApp
//
//  Created by Yogesh Kumar on 10/01/20.
//  Copyright © 2020 Harsh Motwani. All rights reserved.
//

import UIKit

extension Data {
    func toAttributedString() -> NSAttributedString? {
        let options : [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.rtfd,
            .characterEncoding: String.Encoding.utf8
        ]
        
        return try? NSAttributedString(data: self, options: options, documentAttributes: nil)
    }
}

extension NSAttributedString {
    func toData() -> Data? {
        let options : [NSAttributedString.DocumentAttributeKey: Any] = [
            .documentType: NSAttributedString.DocumentType.rtfd,
            .characterEncoding: String.Encoding.utf8
        ]
        
        let range = NSRange(location: 0, length: length)
        guard let data = try? data(from: range, documentAttributes: options) else {
            return nil
        }
        
        return data
    }
    
    convenience init?(base64EndodedImageString encodedImageString: String) {
        let html = """
        <!DOCTYPE html>
        <html>
        <body>
        <img src="data:image/png;base64,\(encodedImageString)">
        </body>
        </html>
        """
        let data = Data(html.utf8)
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        try? self.init(data: data, options: options, documentAttributes: nil)
    }
}
