//
//  CursorRequestParameters.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/22/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

struct CursorRequestParameters: Encodable {
    var page: Int? = 0
    var pageSize: Int? = 10
}
