import KeychainSwift

public struct KeychainImpl: Keychain {
    private let keychain: KeychainSwift

    public init() {
        let keychain = KeychainSwift()
        keychain.synchronizable = false
        self.keychain = keychain
    }

    public func save(type: KeychainType, value: String) {
        value.isEmpty 
            ? keychain.delete(type.rawValue)
            : keychain.set(value, forKey: type.rawValue)
    }

    public func load(type: KeychainType) -> String {
        keychain.get(type.rawValue) ?? ""
    }

    public func delete(type: KeychainType) {
        keychain.delete(type.rawValue)
    }

    public func clear() {
        keychain.clear()
    }
}
