//
//  LeoLocalizedError.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/1/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

public protocol ILeoLocalizedError {
    var info: (title: String, description: String?) { get }
}

public extension ILeoLocalizedError {
    var title: String {
        return info.title
    }

    var description: String? {
        return info.description
    }

    var infoString: String {
        var result = "\(info.title)"
        let description = info.description ?? ""
        if !description.isEmptyOrWhitespace() {
            result += ": \(description)"
        }
        return result
    }
}
