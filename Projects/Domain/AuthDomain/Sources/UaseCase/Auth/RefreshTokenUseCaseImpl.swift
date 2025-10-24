import Foundation
import Combine
import AuthDomainInterface

public class RefreshTokenUseCaseImpl: RefreshTokenUseCase {
    let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute() -> AnyPublisher<Void, Error> {
        repository.refreshToken()
    }
}
