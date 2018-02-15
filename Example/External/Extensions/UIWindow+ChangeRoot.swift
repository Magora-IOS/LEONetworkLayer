
import Foundation
import UIKit

let animationDuration = 0.65

extension UIWindow {
    
    func changeRootViewController(_ viewController: UIViewController, animated: Bool = true) {
        if self.rootViewController != nil {
            rootViewController = viewController
            
            UIView.transition(with: self,
                              duration: animated ? animationDuration : 0,
                              options: .transitionFlipFromRight,
                              animations: nil,
                              completion: nil)
        } else {
            rootViewController = viewController
        }
    }
}
