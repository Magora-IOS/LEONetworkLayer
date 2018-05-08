import ObjectMapper



public class InstantDateTransformISO8601: TransformType {
    
    public typealias Object = Date
    public typealias JSON = String
    
    
    //MARK: - Properties
    private static var formatter: DateFormatter = {
        var result = DateFormatter()
        result.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        result.timeZone = TimeZone(secondsFromGMT: 0)
        return result
    }()
    
    
    //MARK: - Lifecycle
    public init() {
        
    }
    
   
    
    
    //MARK: - Transform
    open func transformFromJSON(_ value: Any?) -> Object? {
        guard let string = value as? String else {
            return nil
        }
        
        return type(of: self).formatter.date(from: string)
    }
    
    
    open func transformToJSON(_ value: Object?) -> JSON? {
        guard let date = value else {
            return nil
        }
        
        return type(of: self).formatter.string(from: date)
    }
}

