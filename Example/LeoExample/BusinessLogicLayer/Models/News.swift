//
//  News.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/22/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

struct News {
    let id: String
    var title: String?
    var description: String?
    var createDate: Date?

    init(id: String) {
        self.id = id
    }

    init(_ dto: NewsDTO) {
        self.init(id: dto.id)
        self.title = dto.title
        self.description = dto.description
        self.createDate = dto.createDate
    }
}


