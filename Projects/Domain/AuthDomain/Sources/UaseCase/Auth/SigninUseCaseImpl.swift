import Foundation
import Combine
import AuthDomainInterface

public class SigninUseCaseImpl: SigninUseCase {
    let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute(req: SigninRequestParams) -> AnyPublisher<Void, Error> {
        repository.signin(req: req)
    }
}
