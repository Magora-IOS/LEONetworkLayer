//
//  LeoApiError+Localization.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/1/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import LEONetworkLayer

extension LeoBaseError: ILeoLocalizedError {
    public var info: (title: String, description: String?) {
        return (title: self.rawCode, description: self.message)
    }
}
