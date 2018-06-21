import Foundation



public protocol ErrorProtocol: class, LocalizedError, CustomStringConvertible {
    

    //Source of error (class, layer, etc)
    var domain: String { get }
    
    var desc: String? { get }
    
    //A localized message describing the reason for the failure.
    var reason: String? { get }
    
    //A localized message describing how one might recover from the failure.
    var recoverySuggestion: String? { get }
    
    //A localized message providing "help" text if the user requests help.
    var help: String? { get }
   
    //For comparison of specific error (e.g. check "no internet")
    var code: Int? { get set }
    
    var underlyingError: Swift.Error? { get set }
    

    //Builder
    init(domain: String)
    init(domain: String, _ description: String?)
    
    typealias BuildErrorClosure = (ErrorProtocol) -> Void
    func build(_ builder: BuildErrorClosure)
    
    
    //Computable
    var fullDescription: String { get }

}



open class ErrorObject: ErrorProtocol {
    
    public func build(_ builder: BuildErrorClosure) {
        builder(self)
    }

    
    
    //MARK: - Properties
    public let domain: String
    public var desc: String?
    public var reason: String?
    public var recoverySuggestion: String?
    public var help: String?
    
    public var code: Int?
    public var underlyingError: Error?
    
    
    //MARK: - Lifecycle
    public required init(domain: String, _ description: String?) {
        self.domain = domain
        self.desc = description
    }
    
    public convenience required init(domain: String) {
        self.init(domain: domain, nil)
    }
    

    
    
    //MARK: - Computable
    public var fullDescription: String {
        var result = "Domain: \(self.domain)\n"
        
        if let description = self.desc {
            result.append("Description: \(description)\n")
        }
        if let reason = self.reason {
            result.append("Reason: \(reason)\n")
        }
        if let recovery = self.recoverySuggestion {
            result.append("Recovery: \(recovery)\n")
        }
        if let help = self.help {
            result.append("Help: \(help)\n")
        }
        if let underlying = self.underlyingError {
            result.append("Underlying: [\(underlying)]\n")
        }
        
        return result
    }
    
}




extension ErrorObject: Swift.Error {
    public var localizedDescription: String {
        return self.fullDescription
    }
}



extension ErrorObject: LocalizedError {
    public var errorDescription: String? {
        return self.fullDescription
    }
    
    public var failureReason: String? {
        return self.reason
    }
    
    public var helpAnchor: String? {
        return self.help
    }
}



extension ErrorObject: CustomStringConvertible {
    public var description: String {
        return self.fullDescription
    }
}
