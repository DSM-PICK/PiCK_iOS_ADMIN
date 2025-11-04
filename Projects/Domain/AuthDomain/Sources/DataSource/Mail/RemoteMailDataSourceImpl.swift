import AuthDomainInterface
import BaseDomain
import Combine

public final class RemoteMailDataSourceImpl: BaseRemoteDataSource<EmailAPI>, RemoteMailDataSource {
    
    public func emailSend(req: EmailSendRequestParams) -> AnyPublisher<Void, any Error> {
        request(.emailSend(req))
            .tryMap { _ in }
            .eraseToAnyPublisher()
    }

    public func codeCheck(req: CodeCheckRequestParams) -> AnyPublisher<Bool, any Error> {
        request(.codeCheck(req))
            .tryMap { response in
                try response.map(Bool.self)
            }
            .eraseToAnyPublisher()
    }
}
