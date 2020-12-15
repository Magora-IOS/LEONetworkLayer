//
//  LeoApiError+Localization.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 12/16/20.
//  Copyright © 2020 Yuriy Savitskiy. All rights reserved.
//

import LEONetworkLayer

extension LeoApiError: ILeoLocalizedError {
    public var info: (title: String, description: String?) {
        return (title: self.message ?? L10n.Errors.Unknown.title, description: nil)
    }
}
