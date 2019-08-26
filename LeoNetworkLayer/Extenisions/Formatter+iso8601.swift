//
//  Formatter+iso8601.swift
//  LeoNetworkLayer
//
//  Created by Yuriy Savitskiy on 8/26/19.
//  Copyright © 2019 Yuriy Savitskiy. All rights reserved.
//

import Foundation

public extension Formatter {
    static func iso8601LeoDateTimeFormatter(withFormat: ISO8601LeoDateTimeFormat) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = withFormat.rawValue
        return formatter
    }
}

public extension Date {
    func iso8601(withFormat: ISO8601LeoDateTimeFormat) -> String {
        return Formatter.iso8601LeoDateTimeFormatter(withFormat: withFormat).string(from: self)
    }
}

public extension String {
    func iso8601(withFormat: ISO8601LeoDateTimeFormat) -> Date? {
        return Formatter.iso8601LeoDateTimeFormatter(withFormat: withFormat).date(from: self)
    }
}


public enum ISO8601LeoDateTimeFormat: String {
    case withMilliseconds = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case withMoreMilliseconds = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    case dateOnly = "yyyy-MM-dd"
}
