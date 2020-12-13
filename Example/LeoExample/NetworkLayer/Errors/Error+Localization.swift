//
//  Error+Localization.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 12/10/20.
//  Copyright © 2020 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import LEONetworkLayer

extension Error {
    func localizedInfo() -> (title: String, description: String?)  {
        ZonaError.getFrom(data: self)
    }
}

extension NSError {
    func localizedInfo() -> (title: String, description: String?)  {
        ZonaError.getFrom(data: self)
    }
}

class ZonaError {
    static func getFrom(data: Any) -> (title: String, description: String?) {
        var result: (title: String, description: String?)
        if let error = data as? ILeoLocalizedError {
            result.title = error.info.title
            result.description = error.info.description
        } else {
            if let localError =  (data as? Error) ?? (data as? NSError) {
                result.title = localError.localizedDescription
                result.description = nil
            } else {
                result.title = L10n.Errors.Unknown.title
                result.description = nil
            }
        }
        return result
    }
}
