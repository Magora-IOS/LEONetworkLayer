import ObjectMapper



open class DateTransformMiliseconds: TransformType {
    
    public init() {        
    }
    
    
    open func transformFromJSON(_ value: Any?) -> Date? {
        if let double = value as? Double {
            return Date(timeIntervalSince1970: TimeInterval(double / 1000.0))
        }
         else if let string = value as? String {
            return self.transformFromJSON(Double(string))
        } else {
            return nil
        }
    }
    
    
    open func transformToJSON(_ value: Date?) -> Double? {
        guard let date = value else {
            return nil
        }
        
        return Double(date.timeIntervalSince1970) * 1000.0
    }
}
