import Foundation

public protocol ChangePasswordRepository {
    func changePassword(req: PasswordChangeRequestParams) async throws
}
