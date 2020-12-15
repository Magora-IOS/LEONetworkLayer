//
//  LeoProviderError+Description.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 7/31/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation
import LEONetworkLayer
import Moya

extension LeoProviderError: ILeoLocalizedError {
    public var info: (title: String, description: String?) {
        var result: (title: String, description: String?)
        switch self.errorCode {
        case .serverError:
            result.title = L10n.Errors.LeoProvider.ServerError.title
            result.description = L10n.Errors.LeoProvider.ServerError.description
        case .securityError:
            result.title = L10n.Errors.LeoProvider.SecurityError.title
            result.description = L10n.Errors.LeoProvider.SecurityError.description
        case .badLeoResponse:
            result.title = L10n.Errors.LeoProvider.BadLeoResponse.title
            result.description = L10n.Errors.LeoProvider.BadLeoResponse.description
        case .timeoutError:
            result.title = L10n.Errors.LeoProvider.TimeoutError.title
            result.description = L10n.Errors.LeoProvider.TimeoutError.description
        case .leoBaseError:
            return self.underlyingLocalizedInfo()
        case .connectionFailed:
            result.title = L10n.Errors.LeoProvider.ConnectionFailed.title
            result.description = L10n.Errors.LeoProvider.ConnectionFailed.description
        case .moyaError:
            return self.underlyingLocalizedInfo()            
        default:
            result.title = String(describing: self)
            result.description = nil
        }
        return result
    }
}
