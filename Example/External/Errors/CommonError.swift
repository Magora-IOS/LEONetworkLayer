import Foundation


enum CommonError: ErrorObjectProvider {
    
    case unknown
    case raw(message: String)
    case disposed
    
    
    var object: Swift.Error {
        //TODO: localize
        let result = ErrorObject(domain: "L10n.Common.error")
        
        
        switch self {
        case .unknown:
            result.desc = "Unknown"
            
        case .raw(let message):
            result.desc = message
            
        case .disposed:
            result.desc = "Deallocated"
        }
        
        return result
    }
    
    
 
}

