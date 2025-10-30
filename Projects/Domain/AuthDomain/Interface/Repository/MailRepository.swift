import Combine

public protocol MailRepository {
    func emailSend(req: EmailSendRequestParams) -> AnyPublisher<Void, Error>
}
