import Foundation

extension String
{
    /**
     Indicates whether a specified string is null, empty, or consists only of white-space characters
     
     - Author:
     Yuriy Savitskiy
     
     - Version:
     1.0
     */
    func isEmptyOrWhitespace() -> Bool {
        if self.isEmpty {
            return true
        }
        
        let whitespaceSet = CharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespaceSet).isEmpty
    }
    
    /**
     Removes number trailing characters from the current String object.
     
     - Parameters:
     - length: number of characters on the left.
     - trailing: trailing. default is ...
     
     - Version:
     1.0
     */
    func truncate(length: Int, trailing: String = "...") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
    
    /**
     Return left part of the string
     
     - Parameters:
     - length: number of characters on the left.
     
     - Version:
     1.0
     */
    func left(_ length: Int)->String {
        if (self.count <= length) {
            return self
        }
        return String( Array(self).prefix(upTo: length) )
    }
}
