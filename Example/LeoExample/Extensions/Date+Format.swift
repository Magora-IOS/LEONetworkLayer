//
//  Date+Format.swift
//  LeoExample
//
//  Created by Yuriy Savitskiy on 8/26/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

extension Date {
    var dateTimeNewsFormat: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        formatter.dateFormat = "d MMMM yyyy HH:mm"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: self)
    }
}
