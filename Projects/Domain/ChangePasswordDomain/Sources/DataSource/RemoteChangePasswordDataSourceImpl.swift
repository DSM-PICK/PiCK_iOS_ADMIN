import ChangePasswordDomainInterface
import BaseDomain
import Foundation
import Core
import Combine

public final class RemoteChangePasswordDataSourceImpl: BaseRemoteDataSource<ChangePasswordAPI>, RemoteChangePasswordDataSource {

    public func changePassword(req: PasswordChangeRequestParams) -> AnyPublisher<Void, Error> {
        request(.changePassword(req))
            .tryMap { _ in () }
            .eraseToAnyPublisher()
    }
}
