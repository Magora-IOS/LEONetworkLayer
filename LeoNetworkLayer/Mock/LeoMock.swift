//
//  LeoMock.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 7/29/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

public enum LeoMock {
    case none
    case immediately
    case delay(TimeInterval)
}
