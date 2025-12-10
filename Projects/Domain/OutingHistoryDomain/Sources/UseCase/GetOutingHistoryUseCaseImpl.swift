import Foundation
import OutListDomainInterface

public class GetOutingHistoryUseCaseImpl: GetOutingHistoryUseCase {
    private let repository: OutingHistoryRepository

    public init(repository: OutingHistoryRepository) {
        self.repository = repository
    }

    public func execute() async throws -> [OutingHistoryEntity] {
        try await repository.getOutingHistory()
    }
}
