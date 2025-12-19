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

    public func returnStudents(ids: [String]) async throws {
        try await dataSource.returnStudents(ids: ids)
    }

    public func getEarlyReturn(floor: Int, status: String) async throws -> [EarlyReturnEntity] {
        try await dataSource.getEarlyReturn(floor: floor, status: status).map { $0.toEntity() }
    }
}
