import UIKit


class ErrorAlert {
    
    
    @discardableResult
    init(error: Error, presenter: UIViewController?, okHandler: (()->Void)? = nil) {
        let title = "L10n.Common.error"
        var message = ""
        
        
        
        if error.isNoInternet {
            message = "L10n.Common.noInternet"
        //} else if let apiBusinessMessage = error.apiBusinessMessage {
        //    message = apiBusinessMessage
        } else {
            message = error.localizedDescription
        }
        
        
        #if DEBUG
        if let custom = error as? ErrorProtocol {
            Log("Error Alert:\n\(custom.fullDescription)")
        }
        #endif
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "L10n.Common.ok", style: .cancel, handler: { _ in
            okHandler?()
        }))
        
        presenter?.present(alert, animated: true, completion: nil)
    }
}
