import NeedleFoundation
import SwiftUI
import Core
import SigninFeature
import SigninFeatureInterface
import SignupFeatureInterface
import OnboardingFeature
import OnboardingFeatureInterface
import HomeFeatureInterface
import AllTabFeatureInterface

public final class AppComponent: BootstrapComponent, HomeDependency, AllTabDependency {

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
    private var signupFlowComponent: SignupFlowComponent {
        shared { SignupFlowComponent(parent: self) }
    }
    var secretKeyFactory: any SecretKeyFactory { signupFlowComponent }
    var verifyEmailFactory: any VerifyEmailFactory { signupFlowComponent }
    var passwordFactory: any PasswordFactory { signupFlowComponent }
    var infoSettingFactory: any InfoSettingFactory { signupFlowComponent }
    var onboardingFactory: any OnboardingFactory {
        OnboardingComponent(parent: self)
    }
    var homeFactory: any HomeFactory {
        HomeComponent(parent: self)
    }
    var allTabFactory: any AllTabFactory {
        AllTabComponent(parent: self)
    }
}
