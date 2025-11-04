import Foundation
import Combine
import AuthDomainInterface

public class SecretKeyUseCaseImpl: SecretKeyUseCase {
    let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute(req: SecretKeyRequestParams) -> AnyPublisher<Bool, Error> {
        repository.secretKey(req: req)
    }
}
