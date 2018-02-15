import Foundation


protocol KeyValueStorage {

	func setValue(value: Any?, key: KeyValueStorageKey) -> Bool
	func getValue(key: KeyValueStorageKey) -> Any?
	
}
