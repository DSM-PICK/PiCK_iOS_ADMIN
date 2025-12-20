import ChangePasswordDomainInterface
import Foundation
import Combine

public final class PasswordChangeUseCaseImpl: PasswordChangeUseCase {
    private let changePasswordRepository: any ChangePasswordRepository

    public init(changePasswordRepository: any ChangePasswordRepository) {
        self.changePasswordRepository = changePasswordRepository
    }

    public func execute(req: PasswordChangeRequestParams) -> AnyPublisher<Void, Error> {
        changePasswordRepository.changePassword(req: req)
    }
}
