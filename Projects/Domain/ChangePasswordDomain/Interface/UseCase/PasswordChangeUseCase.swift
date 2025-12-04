import Foundation

public protocol PasswordChangeUseCase {
    func execute(req: PasswordChangeRequestParams) async throws
}
