//
//  LeoBaseObject.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 7/30/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

public struct LeoBaseObject: Decodable {
    public var code: LeoCode

    public var success: Bool {
        return code == .success
    }
}
