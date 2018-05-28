import UIKit




extension UIRefreshControl {
    
    
    func beginRefreshingManually(animated: Bool) {
        
        if let scrollView = self.superview as? UIScrollView {
            let offset = CGPoint(x: 0, y: scrollView.contentOffset.y - self.frame.height)
            scrollView.setContentOffset(offset, animated: animated)
        }
        
        self.beginRefreshing()
        self.sendActions(for: .valueChanged)
    }
    
}
