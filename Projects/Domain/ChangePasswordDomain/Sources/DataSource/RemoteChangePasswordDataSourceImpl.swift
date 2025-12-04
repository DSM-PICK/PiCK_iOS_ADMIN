import ChangePasswordDomainInterface
import BaseDomain
import Foundation

public final class RemoteChangePasswordDataSourceImpl: BaseRemoteDataSource<ChangePasswordAPI>, RemoteChangePasswordDataSource {
    public func changePassword(req: PasswordChangeRequestParams) async throws {
        _ = try await request(.changePassword(req))
    }
}
