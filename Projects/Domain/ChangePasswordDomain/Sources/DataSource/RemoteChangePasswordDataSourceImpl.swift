import ChangePasswordDomainInterface
import BaseDomain
import Combine

public final class RemoteChangePasswordDataSourceImpl: BaseRemoteDataSource<ChangePasswordAPI>, RemoteChangePasswordDataSource {
    public func changePassword(req: PasswordChangeRequestParams) -> AnyPublisher<Void, Error> {
        request(.changePassword(req))
            .tryMap { response in
                return ()
            }
            .eraseToAnyPublisher()
    }
}
