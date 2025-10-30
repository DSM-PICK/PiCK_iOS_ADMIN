import Combine

public protocol RemoteMailDataSource {
    func emailSend(req: EmailSendRequestParams) -> AnyPublisher<Void, Error>
}
