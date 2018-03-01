import Foundation
import LEONetworkLayer



extension Error {
    
    
    
    
    var apiBusinessMessage: String? {
        
        if let object = self as? ErrorProtocol {
            return object.underlyingError?.apiBusinessMessage
            
        } else if let leo = self as? LEONetworkLayer.NetworkLayerError {
            if case let LEONetworkLayer.NetworkLayerError.businessProblem(_, errors) = leo {
                guard let errors = errors else {
                    return nil
                }
                
                return errors.reduce("", { (result, error) in
                    let title = NSLocalizedString("api.error." + error.rawCode, comment: "")
                    let content = error.message
                    return result?.appending("\(title)\n\(content)\n")
                })
            } else {
                return nil
            }
            
        } else {
            return nil
        }
    }
}
