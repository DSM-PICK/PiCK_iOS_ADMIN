import Foundation
import Combine
import AuthDomainInterface

public class SignupUseCaseImpl: SignupUseCase {
    let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute(req: SignupRequestParams) -> AnyPublisher<Void, Error> {
        repository.signup(req: req)
    }
}
