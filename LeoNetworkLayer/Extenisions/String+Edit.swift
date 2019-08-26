//
//  String+Edit.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/1/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

public extension String {

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
}
