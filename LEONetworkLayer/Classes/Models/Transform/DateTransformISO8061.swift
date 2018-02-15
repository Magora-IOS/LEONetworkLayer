import ObjectMapper



public class DateTransformISO8061: TransformType {
	
    //MARK: - Properties
	private let zeroTimezone: Bool
    private let dateFormat: String
    
    
    //MARK: - Lifecycle
	public init(zeroTimezone: Bool = true) {
        self.zeroTimezone = zeroTimezone
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
	}
    
    
    public init(withFormat format: String) {
        self.zeroTimezone = false
        self.dateFormat = format
    }
    
    
    //MARK: - Transform
    open func transformFromJSON(_ value: Any?) -> Date? {
		guard let string = value as? String else {
            return nil
        }
        
		return self.dateFormatter().date(from: string)
    }
    
    
    open func transformToJSON(_ value: Date?) -> String? {
		guard let date = value else {
            return nil
        }
        
		return self.dateFormatter().string(from: date)
    }
	
    
    
    //MARK: - Routines
	private func dateFormatter() -> DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = self.dateFormat
        
		if self.zeroTimezone {
			dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		}
		
		return dateFormatter
	}
	
}
