import UIKit

extension UIView {
    
    private class func instantiate<T: UIView>(nibNamed: String) -> T? {
        return Bundle.main.loadNibNamed(nibNamed, owner: self, options: nil)?.first as? T
    }
    
    class func loadFromNibNamed(nibNamed: String) -> Self? {
        return instantiate(nibNamed: nibNamed)
    }
    
    class func loadFromNib() -> Self? {
        return instantiate(nibNamed: nameOfClass)
    }
    
    class func nib() -> UINib? {
        return UINib(nibName: nameOfClass, bundle: .main)
    }
}
