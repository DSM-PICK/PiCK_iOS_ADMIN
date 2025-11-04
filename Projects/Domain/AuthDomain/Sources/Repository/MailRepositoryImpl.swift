import Foundation
import AuthDomainInterface
import Combine
import Core
import BaseDomain

public class MailRepositoryImpl: MailRepository {
    private let remoteDataSource: RemoteMailDataSource

    public init(
        remoteDataSource: RemoteMailDataSource
    ) {
        self.remoteDataSource = remoteDataSource
    }

    public func emailSend(req: EmailSendRequestParams) -> AnyPublisher<Void, any Error> {
        remoteDataSource.emailSend(req: req)
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    public func codeCheck(req: CodeCheckRequestParams) -> AnyPublisher<Bool, Error> {
        remoteDataSource.codeCheck(req: req)
            .map { response in
                return response
            }
            .eraseToAnyPublisher()
    }
}
