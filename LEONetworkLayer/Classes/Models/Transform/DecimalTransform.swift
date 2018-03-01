import ObjectMapper



open class DecimalTransform: TransformType {
    
    public typealias Object = Decimal
    public typealias JSON = String
    
    
    public init() {}
    
    
    open func transformFromJSON(_ value: Any?) -> Decimal? {
        if let string = value as? String {
            return Decimal(string: string)
        } else if let number = value as? NSNumber {
            return number.decimalValue
        } else if let double = value as? Double {
            return Decimal(floatLiteral: double)
        }
        return nil
    }
    
    open func transformToJSON(_ value: Decimal?) -> String? {
        guard let value = value else { return nil }
        return value.description
    }
}

