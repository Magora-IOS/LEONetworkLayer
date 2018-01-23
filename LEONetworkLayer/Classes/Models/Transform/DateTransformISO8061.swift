import ObjectMapper

class DateTransformISO8061: TransformType {
	
	var zeroTimezone: Bool = false
    var dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
	init(zeroTimezone: Bool = true) {
		if zeroTimezone {
			self.zeroTimezone = true
			dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		}
	}
    
    init(withFormat format: String) {
        dateFormat = format
    }
    
    open func transformFromJSON(_ value: Any?) -> Date? {
		guard let dateString = value as? String else { return nil }
		return dateFormatter().date(from: dateString)
    }
    
    open func transformToJSON(_ value: Date?) -> String? {
		guard let date = value else { return nil }
		return dateFormatter().string(from: date)
    }
	
	private func dateFormatter() -> DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = dateFormat
		if zeroTimezone {
			dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		}
		
		return dateFormatter
	}
	
}
