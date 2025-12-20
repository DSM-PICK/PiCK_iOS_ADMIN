import Foundation
import AcceptDomainInterface
import Combine

public class UpdateEarlyReturnStatusUseCase: UpdateEarlyReturnStatusUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute(status: String, idList: [String]) -> AnyPublisher<Void, Error> {
        repository.updateEarlyReturnStatus(status: status, idList: idList)
    }
}
