import Foundation

import Domain

import Swinject

public final class UseCaseAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(LoginUseCase.self) { resolver in
            LoginUseCase(repository: resolver.resolve(AuthRepository.self)!)
        }
        container.register(RefreshTokenUseCase.self) { resolver in
            RefreshTokenUseCase(repository: resolver.resolve(AuthRepository.self)!)
        }
        container.register(RefreshTokenUseCase.self) { resolver in
            RefreshTokenUseCase(repository: resolver.resolve(AuthRepository.self)!)
        }
    }
}
