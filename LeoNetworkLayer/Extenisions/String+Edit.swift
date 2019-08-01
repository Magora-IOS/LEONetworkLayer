//
//  String+Edit.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/1/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

extension String {
    /**
     Indicates whether a specified string is null, empty, or consists only of white-space characters
     
     - Author:
     Yuriy Savitskiy
     
     - Version:
     1.0
     */
    func isEmptyOrWhitespace() -> Bool {
        if self.isEmpty {
            return true
        }
        
        let whitespaceSet = CharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespaceSet).isEmpty
    }
    
    /**
     Removes number trailing characters from the current String object.
     
     - Parameters:
     - length: number of characters on the left.
     - trailing: trailing. default is ...
     
     - Version:
     1.0
     */
    func truncate(length: Int, trailing: String = "...") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}
