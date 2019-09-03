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
    var title: String
    var description: String?
    var createDate: Date?

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case createDate
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try? container.decode(String.self, forKey: .description)

        if let dateString = try? container.decode(String.self, forKey: .createDate) {
            self.createDate = dateString.iso8601(withFormat: .dateTimeUtc0msExtended)
        } else {
            self.createDate = nil
        }
        
    }
}
