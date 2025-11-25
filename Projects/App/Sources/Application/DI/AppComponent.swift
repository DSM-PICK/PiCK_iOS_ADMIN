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
import AllTabFeature
import AllTabFeatureInterface
import AcceptFeature
import AcceptFeatureInterface

public final class AppComponent: BootstrapComponent, HomeDependency, AllTabDependency, PlanDependency, AcceptDependency {
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
    var secretKeyFactory: any SecretKeyFactory {
        SecretKeyComponent(parent: self)
    }
    var verifyEmailFactory: any VerifyEmailFactory {
        VerifyEmailComponent(parent: self)
    }
    var passwordFactory: any PasswordFactory {
        PasswordComponent(parent: self)
    }
    var infoSettingFactory: any InfoSettingFactory {
        InfoSettingComponent(parent: self)
    }
    var onboardingFactory: any OnboardingFactory {
        OnboardingComponent(parent: self)
    }
    var homeFactory: any HomeFactory {
        HomeComponent(parent: self)
    }
    var allTabFactory: any AllTabFactory {
        AllTabComponent(parent: self)
    }
    var acceptFactory: any AcceptFactory {
        AcceptComponent(parent: self)
    }
}
