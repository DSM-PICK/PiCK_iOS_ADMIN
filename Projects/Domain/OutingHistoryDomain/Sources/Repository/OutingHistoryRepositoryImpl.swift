import Foundation
import Combine
import OutingHistoryDomainInterface

public class OutingHistoryRepositoryImpl: OutingHistoryRepository {
    private let dataSource: OutingHistoryDataSource

    public init(dataSource: OutingHistoryDataSource) {
        self.dataSource = dataSource
    }

    public func getOutingHistory() -> AnyPublisher<[OutingHistoryEntity], Error> {
        dataSource.getOutingHistory()
            .map { $0.map { $0.toEntity() } }
            .eraseToAnyPublisher()
    }
}
