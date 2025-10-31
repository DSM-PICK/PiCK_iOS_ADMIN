import Foundation
import Combine
import AuthDomainInterface

public class CodeCheckUseCaseImpl: CodeCheckUseCase {
    let repository: MailRepository

    public init(repository: MailRepository) {
        self.repository = repository
    }

    public func execute(req: CodeCheckRequestParams) -> AnyPublisher<Bool, Error> {
        repository.codeCheck(req: req)
    }
}
