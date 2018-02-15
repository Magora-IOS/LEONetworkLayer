import UIKit


protocol Coordinator: class {
    
    
    var completionHandler: ((_ coordinator: Coordinator?) -> ())? {get set}
    
    func start()
}
