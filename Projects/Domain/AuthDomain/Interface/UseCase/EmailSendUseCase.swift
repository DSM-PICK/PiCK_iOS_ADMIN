import Combine

public protocol EmailSendUseCase {
    func execute(req: EmailSendRequestParams) -> AnyPublisher<Void, Error>
}
