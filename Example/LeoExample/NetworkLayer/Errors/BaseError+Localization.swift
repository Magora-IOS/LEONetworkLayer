//
//  BaseError+Localization.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 12/16/20.
//  Copyright © 2020 Yuriy Savitskiy. All rights reserved.
//

import LEONetworkLayer

extension IBaseError {
    func localizedInfo() -> (title: String, description: String?)  {
        var result: (title: String, description: String?)
        if let error = self.underlyingError as? ILeoLocalizedError {
            return error.info
        } else {
            result.title = L10n.Errors.Unknown.title
            result.description = nil
        }
        return result
    }
}
