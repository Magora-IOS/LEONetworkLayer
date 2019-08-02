//
//  Error+Leo.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/26/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Moya

public extension Error {
    static func toLeoError(_ error: Error ) -> ILeoError? {
        return LeoError.toLeoError(error)
    }
    
    private func toLeoError() -> ILeoError? {
        return LeoError.toLeoError(self)
    }
    
    var localizedLeoError: ILeoLocalizedError? {
        if let localizedError = self.toLeoError() as? ILeoLocalizedError {
            return localizedError
        }
        return nil
    }
    
    var leoError: ILeoError? {
        return self.toLeoError()
    }
    
    var moyaError: MoyaError? {
        if let moyaError = self as? MoyaError {
            return moyaError
        }
        return nil
    }        
}

