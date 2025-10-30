import Foundation
import AuthDomainInterface
import Combine
import Core
import BaseDomain

public class MailRepositoryImpl: MailRepository {
    private let remoteDataSource: RemoteMailDataSource
//    private var cancellables = Set<AnyCancellable>()

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
}
