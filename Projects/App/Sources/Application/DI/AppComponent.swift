import NeedleFoundation
import SwiftUI
import KeychainModule
import AuthFeature
import AuthFeatureInterface

public final class AppComponent: BootstrapComponent {
    private let _keychain: any Keychain

    init(keychain: any Keychain) {
        self._keychain = keychain
    }

    public func makeRootView() -> some View {
        authFactory.makeView()
    }

    public var keychain: any Keychain {
        shared {
            _keychain
        }
    }
}

// MARK: - Auth
public extension AppComponent {
    var authFactory: any AuthFactory {
        AuthComponent(parent: self)
    }
}
