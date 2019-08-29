//
//  LeoBaseObject.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 7/30/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

open class LeoBaseObject: Codable {
    public var code: LeoCodes

    public var success: Bool {
        return code == .success
    }
}
