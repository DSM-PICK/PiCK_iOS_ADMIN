import ChangePasswordDomainInterface
import Foundation

public final class PasswordChangeUseCaseImpl: PasswordChangeUseCase {
    private let changePasswordRepository: any ChangePasswordRepository

    public init(changePasswordRepository: any ChangePasswordRepository) {
        self.changePasswordRepository = changePasswordRepository
    }

    public func execute(req: PasswordChangeRequestParams) async throws {
        try await changePasswordRepository.changePassword(req: req)
    }
}
