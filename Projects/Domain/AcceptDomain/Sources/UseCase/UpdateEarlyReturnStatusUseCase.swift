import Foundation
import AcceptDomainInterface

public class UpdateEarlyReturnStatusUseCase: UpdateEarlyReturnStatusUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute(status: String, idList: [String]) async throws {
        try await repository.updateEarlyReturnStatus(status: status, idList: idList)
    }
}
