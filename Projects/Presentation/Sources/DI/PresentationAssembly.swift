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
    }
}
