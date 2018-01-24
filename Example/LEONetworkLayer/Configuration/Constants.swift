import Foundation



protocol DontAutocompleteMe_ConstantsRequirements: class {
    static var apiBaseURL: URL { get }
    static var apiVersion: String { get }
}




class Constants {
    
    //MARK: - Interface
    static var get: DontAutocompleteMe_ConstantsRequirements.Type {
        #if RELEASE
            return ConstantsRelease.self
        #elseif DEBUG
            return ConstantsDebug.self
        #else
            //This generates a compiler warning
            return self.constantsNotAvailable
        #endif
    }
    
    
    @available(iOS, introduced: 100.0, deprecated: 100.0, message: "Use valid Build Scheme")
    private static var constantsNotAvailable: ConstantsBase.Type {
        //Just for compilation
        return ConstantsBase.self
    }
    
    
    private init() {
        
    }
    
    
    
    
    
    
    //MARK: - Constants
    private class ConstantsBase: DontAutocompleteMe_ConstantsRequirements {
        //class var used for override ability
        class var apiBaseURL: URL { return URL(string: "http://standard.java.magora.team:8080/api")! }
        class var apiVersion: String { return "v1" }
    }
    
    
    private class ConstantsRelease: ConstantsBase {
        
    }
    
    
    
    private class ConstantsDebug: ConstantsBase {
    }
        
}
