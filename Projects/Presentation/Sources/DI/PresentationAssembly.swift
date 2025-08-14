import Foundation

import Swinject

import Core
import Domain

public final class PresentationAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(OnboardingViewController.self) { resolver in
            OnboardingViewController(resolver.resolve(OnboardingViewModel.self)!)
        }
        container.register(OnboardingViewModel.self) { resolver in
            OnboardingViewModel(
                refreshTokenUseCase: resolver.resolve(RefreshTokenUseCase.self)!,
                loginUseCase: resolver.resolve(LoginUseCase.self)!
            )
        }

        container.register(LoginViewController.self) { resolver in
            LoginViewController(reactor: resolver.resolve(LoginReactor.self)!)
        }
        container.register(LoginReactor.self) { resolver in
            LoginReactor(
                loginUseCase: resolver.resolve(LoginUseCase.self)!
            )
        }
        
        container.register(VerifyEmailViewModel.self) { resolver in
            VerifyEmailViewModel()
        }
        container.register(VerifyEmailViewController.self) { resolver in
            VerifyEmailViewController(resolver.resolve(VerifyEmailViewModel.self)!)
        }
        container.register(PasswordSettingViewModel.self) { resolver in
            PasswordSettingViewModel()
        }
        container.register(PasswordSettingViewController.self) { resolver in
            PasswordSettingViewController(resolver.resolve(PasswordSettingViewModel.self)!)
        }
        container.register(InfoSettingViewModel.self) { resolver in
            InfoSettingViewModel()
        }
        container.register(InfoSettingViewController.self) { resolver in
            InfoSettingViewController(resolver.resolve(InfoSettingViewModel.self)!)
        }
    }
}
