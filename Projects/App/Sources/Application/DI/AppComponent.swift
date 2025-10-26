import NeedleFoundation
import SwiftUI
import Core
import SigninFeature
import SigninFeatureInterface
import SignupFeature
import SignupFeatureInterface
import OnboardingFeature
import OnboardingFeatureInterface
import HomeFeature
import HomeFeatureInterface

public final class AppComponent: BootstrapComponent, HomeDependency {
    private let _keychain: any Keychain

    init(keychain: any Keychain) {
        self._keychain = keychain
    }

    public func makeRootView() -> some View {
        rootComponent.makeView()
    }

    public var keychain: any Keychain {
        shared {
            _keychain
        }
    }

    var rootComponent: RootComponent {
        shared {
            RootComponent(parent: self)
        }
    }
}

// MARK: - Features
public extension AppComponent {
    var signinFactory: any SigninFactory {
        SigninComponent(parent: self)
    }
    var signupFactory: any SignupFactory {
        SecretKeyComponent(parent: self)
    }
    var onboardingFactory: any OnboardingFactory {
        OnboardingComponent(parent: self)
    }
    var homeFactory: any HomeFactory {
        HomeComponent(parent: self)
    }
}
