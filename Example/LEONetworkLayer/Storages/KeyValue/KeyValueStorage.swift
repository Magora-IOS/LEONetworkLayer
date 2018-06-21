import Foundation


protocol KeyValueStorage {

	func setValue(_ value: Any?, forKey key: KeyValueStorageKey) throws
    func getValue<T>(forKey key: KeyValueStorageKey, type: T.Type) throws -> T?
}
