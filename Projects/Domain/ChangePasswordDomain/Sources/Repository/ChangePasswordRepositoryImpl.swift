import ChangePasswordDomainInterface
import Foundation

public final class ChangePasswordRepositoryImpl: ChangePasswordRepository {
    private let remoteChangePasswordDataSource: any RemoteChangePasswordDataSource

    public init(remoteChangePasswordDataSource: any RemoteChangePasswordDataSource) {
        self.remoteChangePasswordDataSource = remoteChangePasswordDataSource
    }

    public func changePassword(req: PasswordChangeRequestParams) async throws {
        try await remoteChangePasswordDataSource.changePassword(req: req)
    }
}
