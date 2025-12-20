import Foundation
import AcceptDomainInterface
import Combine

public class UpdateApplicationStatusUseCase: UpdateApplicationStatusUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute(status: String, idList: [String]) -> AnyPublisher<Void, Error> {
        repository.updateApplicationStatus(status: status, idList: idList)
    }
}
