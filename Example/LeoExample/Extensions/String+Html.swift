//
//  String+Html.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/26/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import UIKit

extension String
{
    /**
     Converts to Html
     
     - Author:
     Yuriy Savitskiy
     
     - Version:
     1.0
     */

    func html() -> NSMutableAttributedString {
        let data = Data((self).utf8)
        if let attributedString = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            return attributedString
        } else {
            return NSMutableAttributedString()
        }
    }
    
    /**
     Converts to Html + center
     
     - Author:
     Yuriy Savitskiy
     
     - Version:
     1.0
     */

    func htmlCentered() -> NSMutableAttributedString {
        let html = self.html()
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        html.addAttributes([ NSAttributedString.Key.paragraphStyle: style ],
                                         range: NSMakeRange(0, html.length))
        return html
    }
}
