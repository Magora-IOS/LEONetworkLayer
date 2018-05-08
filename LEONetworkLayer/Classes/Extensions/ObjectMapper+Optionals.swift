import ObjectMapper


public extension Map {
    
    public func valueOrNil<T>(_ key: String, nested: Bool? = nil, delimiter: String = ".", file: StaticString = #file, function: StaticString = #function, line: UInt = #line) throws -> T? {
        do {
            let result: T = try self.value(key, nested: nested, delimiter: delimiter, file: file, function: function, line: line)
            return result
        } catch {
            return try self.throwOrNil(error)
        }
    }

    
    public func valueOrNil<T: BaseMappable>(_ key: String, nested: Bool? = nil, delimiter: String = ".", file: StaticString = #file, function: StaticString = #function, line: UInt = #line) throws -> T? {
        do {
            let result: T = try self.value(key, nested: nested, delimiter: delimiter, file: file, function: function, line: line)
            return result
        } catch {
            return try self.throwOrNil(error)
        }
    }
    
    
    
    public func valueOrNil<Transform: TransformType>(_ key: String, nested: Bool? = nil, delimiter: String = ".", using transform: Transform, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) throws -> Transform.Object? {
        do {
            let result: Transform.Object = try self.value(key, nested: nested, delimiter: delimiter, using: transform, file: file, function: function, line: line)
            return result
        } catch {
            return try self.throwOrNil(error)
        }
    }
        
        
    private func throwOrNil<T>(_ error: Error) throws -> T? {
        guard let mapError = error as? MapError, mapError.currentValue == nil else {
            throw error
        }
        return nil
    }
}
