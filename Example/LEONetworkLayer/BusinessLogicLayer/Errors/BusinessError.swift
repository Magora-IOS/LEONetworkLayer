import Foundation



enum BusinessError: ErrorObjectProvider {
    
    case raw(message: String)
    

    
    var object: Swift.Error {
        //TODO: localize
        let result = ErrorObject(domain: "L10n.Common.businessError")
        
        switch self {
    
        case .raw(let message):
            result.desc = message
        }
        
        return result
    }
    
    
}


