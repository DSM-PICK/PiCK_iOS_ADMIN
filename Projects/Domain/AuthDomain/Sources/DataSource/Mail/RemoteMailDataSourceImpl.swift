import AuthDomainInterface
import BaseDomain
import Combine

public final class RemotMailDataSourceImpl: BaseRemoteDataSource<EmailAPI>, RemoteMailDataSource {
    
    public func emailSend(req: EmailSendRequestParams) -> AnyPublisher<Void, any Error> {
        request(.emailSend(req))
            .tryMap { _ in }
            .eraseToAnyPublisher()
    }
}
