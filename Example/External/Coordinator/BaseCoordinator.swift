import Foundation
import UIKit


class BaseCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var completionHandler: ((_ coordinator: Coordinator?) -> ())?
    
    
    func start() {
        
    }
    
    
    
    func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

}
