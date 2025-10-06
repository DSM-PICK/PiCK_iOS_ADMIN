import Foundation
import RxSwift
import AuthDomainInterface

public class LoginUseCaseImpl: LoginUseCase {
    let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute(req: LoginRequestParams) -> Completable {
        return repository.login(req: req)
    }

}
