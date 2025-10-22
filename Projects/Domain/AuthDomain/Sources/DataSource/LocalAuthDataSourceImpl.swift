import Foundation

import RxSwift
import RxMoya
import Moya

import Core
import AuthDomainInterface
import BaseDomain

public struct LocalAuthDataSourceImpl: LocalAuthDataSource {
    private let keychain: any Keychain

    public init(keychain: any Keychain) {
        self.keychain = keychain
    }

    public func logout() {
        keychain.delete(type: .accessToken)
        keychain.delete(type: .refreshToken)
    }
}
