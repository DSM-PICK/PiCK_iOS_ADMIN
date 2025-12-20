import ChangePasswordDomainInterface
import Foundation
import Combine

public final class ChangePasswordRepositoryImpl: ChangePasswordRepository {
    private let remoteChangePasswordDataSource: any RemoteChangePasswordDataSource

    public init(remoteChangePasswordDataSource: any RemoteChangePasswordDataSource) {
        self.remoteChangePasswordDataSource = remoteChangePasswordDataSource
    }

    public func changePassword(req: PasswordChangeRequestParams) -> AnyPublisher<Void, Error> {
        remoteChangePasswordDataSource.changePassword(req: req)
    }
}
