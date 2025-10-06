import Foundation
import RxSwift
import AuthDomainInterface

public class RefreshTokenUseCaseImpl: RefreshTokenUseCase {
    let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func execute() -> Completable {
        return repository.refreshToken()
    }

}
