import Foundation


enum CommonError: ErrorObjectProvider {
    
    case unknown
    case raw(message: String)
    case disposed
    
    //TODO: localize
    var object: Swift.Error {
        let result = ErrorObject(domain: "Common")
        
        
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

