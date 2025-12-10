import Foundation
import OutingHistoryDomainInterface

public class OutingHistoryRepositoryImpl: OutingHistoryRepository {
    private let dataSource: OutingHistoryDataSource
    
    public init(dataSource: OutingHistoryDataSource) {
        self.dataSource = dataSource
    }
    
    public func getOutingHistory() async throws -> [OutingHistoryEntity] {
        try await dataSource.getOutingHistory().map { $0.toEntity() }
    }
}
