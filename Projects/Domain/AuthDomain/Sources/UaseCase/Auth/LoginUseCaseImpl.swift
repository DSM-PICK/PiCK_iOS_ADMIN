import Foundation
import Combine
import AuthDomainInterface

public class LoginUseCaseImpl: LoginUseCase {
    let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute(req: LoginRequestParams) -> AnyPublisher<Void, Error> {
        repository.login(req: req)
    }
}
