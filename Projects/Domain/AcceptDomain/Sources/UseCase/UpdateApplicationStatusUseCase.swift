import Foundation
import AcceptDomainInterface

public class UpdateApplicationStatusUseCase: UpdateApplicationStatusUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute(status: String, idList: [String]) async throws {
        try await repository.updateApplicationStatus(status: status, idList: idList)
    }
}
