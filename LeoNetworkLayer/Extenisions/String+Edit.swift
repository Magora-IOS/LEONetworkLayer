//
//  String+Edit.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/1/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

public extension String {

    func isEmptyOrWhitespace() -> Bool {
        if self.isEmpty {
            return true
        }
        
        let whitespaceSet = CharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespaceSet).isEmpty
    }
}
