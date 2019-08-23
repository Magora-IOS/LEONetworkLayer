//
//  NewsServiceError.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/23/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import LEONetworkLayer

enum NewsServiceError: ILeoError {
    case commonError(Error)
}

extension NewsServiceError: ILeoLocalizedError {
    var info: (title: String, description: String?) {
        switch self {        
        case .commonError(let error):
            if let leoError = error.localizedLeoError {
                return leoError.info
            }
            return (title: L10n.Errors.Unknown.title, description: L10n.Errors.Unknown.description)
        }
    }
}

