//
//  NewsDTO.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/23/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

class NewsDTO: Codable {
    let id: String
    var title: String?
    var description: String?
    //var createDate: Date?        
}
