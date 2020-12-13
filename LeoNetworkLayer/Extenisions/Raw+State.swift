//
//  Raw+State.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 12/10/20.
//  Copyright © 2020 Yuriy Savitskiy. All rights reserved.
//

import Foundation

public extension RawRepresentable where RawValue == Int {
    func hasState(_ state: Self ) -> Bool {
        if case state.rawValue = self.rawValue {
               return true
        }
        return false
    }
}

public extension RawRepresentable where RawValue == String {
    func hasState(_ state: Self ) -> Bool {
        if case state.rawValue = self.rawValue {
               return true
        }
        return false
    }
}

