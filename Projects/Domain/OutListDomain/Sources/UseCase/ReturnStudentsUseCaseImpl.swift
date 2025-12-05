import Foundation
import OutListDomainInterface

public class ReturnStudentsUseCaseImpl: ReturnStudentsUseCase {

    private let repository: OutListRepository

    public init(repository: OutListRepository) {
        self.repository = repository
    }

    public func execute(ids: [String]) async throws {
        try await repository.returnStudents(ids: ids)
    }
}
