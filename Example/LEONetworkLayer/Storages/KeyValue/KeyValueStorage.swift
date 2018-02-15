import Foundation


protocol KeyValueStorage {

    @discardableResult
	func setValue(value: Any?, key: KeyValueStorageKey) -> Bool
	
    func getValue(key: KeyValueStorageKey) -> Any?
}
