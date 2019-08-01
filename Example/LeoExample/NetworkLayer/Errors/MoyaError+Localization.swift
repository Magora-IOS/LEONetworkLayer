//
//  MoyaError_Localization.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/1/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import LEONetworkLayer
import Moya

extension MoyaError: ILeoLocalizedError {
    public var info: (title: String, description: String?) {
        return (title: String(describing: self), description: self.localizedDescription)
    }
}
