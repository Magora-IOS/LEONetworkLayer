import Foundation

extension String {
    /**
     Return left part of the string
     
     - Parameters:
     - length: number of characters on the left.
     
     - Version:
     1.0
     */
    func left(_ length: Int) -> String {
        if (self.count <= length) {
            return self
        }
        return String(Array(self).prefix(upTo: length))
    }
}
