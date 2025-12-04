import Foundation
import OutListDomainInterface

public class OutListRepositoryImpl: OutListRepository {
    private let dataSource: OutListDataSource

    public init(dataSource: OutListDataSource) {
        self.dataSource = dataSource
    }

    public func getOutList(floor: Int) async throws -> [OutListEntity] {
        try await dataSource.getOutList(floor: floor).map { $0.toEntity() }
    }
}
