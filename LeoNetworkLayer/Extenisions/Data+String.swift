//
//  Data+String.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 12/10/20.
//  Copyright © 2020 Yuriy Savitskiy. All rights reserved.
//

import Foundation

public extension Data {
    var hexString: String {
        self.map { String(format: "%02.2hhx", $0) }.joined()
    }
    
    var string: String {
        String(decoding: self, as: UTF8.self)
    }
}
