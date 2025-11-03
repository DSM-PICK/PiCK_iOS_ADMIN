import Foundation
import Combine
import AuthDomainInterface

public class EmailSendUseCaseImpl: EmailSendUseCase {
    let repository: MailRepository

    public init(repository: MailRepository) {
        self.repository = repository
    }

    public func execute(req: EmailSendRequestParams) -> AnyPublisher<Void, Error> {
        repository.emailSend(req: req)
    }
}
