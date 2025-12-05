import Foundation

public protocol RemoteChangePasswordDataSource {
    func changePassword(req: PasswordChangeRequestParams) async throws
}
