import Foundation
import Core

public final class JwtStore {
    public static let shared = JwtStore()
    public static let tokenPrefix = "Bearer "

    private let keyChain: Keychain

    public init(keychain: Keychain = KeychainImpl()) {
        self.keyChain = keychain
    }

    public var accessToken: String? {
        get { loadToken(for: .accessToken) }
        set { saveToken(newValue, for: .accessToken) }
    }

    public var refreshToken: String? {
        get { loadToken(for: .refreshToken) }
        set { saveToken(newValue, for: .refreshToken) }
    }
    
    public var hasValidToken: Bool {
        guard let access = accessToken,
              !access.isEmpty else {
            return false
        }
        return true
    }

    public func toHeader(_ type: KeychainType) -> [String: String] {
        var headers = ["content-type": "application/json"]

        switch type {
        case .accessToken:
            if let token = accessToken {
                headers["Authorization"] = "\(Self.tokenPrefix)\(token)"
            }
        case .refreshToken:
            if let token = refreshToken {
                headers["X-Refresh-Token"] = token
            }
        default:
            break
        }

        return headers
    }

    public func clearTokens() {
        keyChain.delete(type: .accessToken)
        keyChain.delete(type: .refreshToken)
    }
    
    private func loadToken(for type: KeychainType) -> String? {
        let token = keyChain.load(type: type)
        return token.isEmpty ? nil : token
    }
    
    private func saveToken(_ token: String?, for type: KeychainType) {
        guard let token = token, !token.isEmpty else {
            keyChain.delete(type: type)
            return
        }

        let cleanToken = token.replacingOccurrences(of: Self.tokenPrefix, with: "")
        keyChain.save(type: type, value: cleanToken)
    }
}
