import Foundation
import AuthDomainInterface
import Core

public class LocalAuthDataSourceImpl: LocalAuthDataSource {
    private let keychain: any Keychain

    public init(keychain: any Keychain) {
        self.keychain = keychain
    }

    public func saveAccessToken(_ token: String) {
        keychain.save(type: .accessToken, value: token)
    }

    public func loadAccessToken() -> String? {
        keychain.load(type: .accessToken)
    }

    public func saveRefreshToken(_ token: String) {
        keychain.save(type: .refreshToken, value: token)
    }

    public func loadRefreshToken() -> String? {
        keychain.load(type: .refreshToken)
    }

    public func saveAccessExp(_ time: String) {
        keychain.save(type: .accessExp, value: time)
    }

    public func loadAccessExp() -> String? {
        keychain.load(type: .accessExp)
    }

    public func saveRefreshExp(_ time: String) {
        keychain.save(type: .refreshExp, value: time)
    }

    public func loadRefreshExp() -> String? {
        keychain.load(type: .refreshExp)
    }

    public func clearTokens() {
        keychain.delete(type: .accessToken)
        keychain.delete(type: .refreshToken)
        keychain.delete(type: .accessExp)
        keychain.delete(type: .refreshExp)
    }
}
