//
//  Raw+MirroState.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 12/10/20.
//  Copyright © 2020 Yuriy Savitskiy. All rights reserved.
//

import Foundation

public protocol MirrorState: RawRepresentable {
}

public extension MirrorState {
    init?(rawValue: String) {
        return nil
    }
        
    var rawValue: String {
        guard let label = Mirror(reflecting: self).children.first?.label else {
            return .init(describing: self)
        }
        return label
    }
}
