import Foundation
import Combine
import OutingHistoryDomainInterface

public class GetOutingHistoryUseCaseImpl: GetOutingHistoryUseCase {
    private let repository: OutingHistoryRepository

    public init(repository: OutingHistoryRepository) {
        self.repository = repository
    }

    public func execute() -> AnyPublisher<[OutingHistoryEntity], Error> {
        repository.getOutingHistory()
    }
}
