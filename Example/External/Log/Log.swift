import Foundation



func Log(_ message: String?, file: StaticString = #file, line: UInt = #line) {
    #if DEBUG
        print("\n\(file): \(line)\n\(message ?? "")\n")
    #endif
}




func Log(_ error: Error?, file: StaticString = #file, line: UInt = #line) {
    Log(error?.localizedDescription, file: file, line: line)
}
