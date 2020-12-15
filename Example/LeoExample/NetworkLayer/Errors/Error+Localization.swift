//
//  Error+Localization.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 12/10/20.
//  Copyright © 2020 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import LEONetworkLayer
import Moya

extension Error {
    func localizedInfo() -> (title: String, description: String?) {
        LeoError.getFrom(data: self)
    }
    
    func underlyingLocalizedInfo() -> (title: String, description: String?) {
        LeoError.getUnderlyingFrom(data: self)
    }
}

extension NSError {
    func localizedInfo() -> (title: String, description: String?)  {
        LeoError.getFrom(data: self)
    }
    
    func underlyingLocalizedInfo() -> (title: String, description: String?) {
        LeoError.getUnderlyingFrom(data: self)
    }
}

class LeoError {
    static func getFrom(data: Any) -> (title: String, description: String?) {
        var result: (title: String, description: String?)
        if let error = data as? ILeoLocalizedError {
            return error.info
        } else {
            if let localError =  (data as? Error) ?? (data as? NSError) {
                result.title = localError.localizedDescription
                result.description = nil
            } else {
                result.title = L10n.Errors.Unknown.title
                result.description = L10n.Errors.Unknown.description
            }
        }
        return result
    }
    
    static func getUnderlyingFrom(data: Any) -> (title: String, description: String?) {
        if  let baseError = data as? IBaseError,
            let underlyingError = baseError.underlyingError {
            
            if let error = (underlyingError as? Error) ?? (underlyingError as? NSError) {
                return error.localizedInfo()
            }
        }
        
        return (title: L10n.Errors.Unknown.title,
                description: L10n.Errors.Unknown.description)
    }
}
