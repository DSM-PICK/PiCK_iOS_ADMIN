import Foundation
import Combine
import OutListDomainInterface

public class OutListRepositoryImpl: OutListRepository {
    private let dataSource: OutListDataSource

    public init(dataSource: OutListDataSource) {
        self.dataSource = dataSource
    }

    public func getOutList(floor: Int) -> AnyPublisher<[OutListEntity], Error> {
        dataSource.getOutList(floor: floor)
            .map { $0.map { $0.toEntity() } }
            .eraseToAnyPublisher()
    }

    public func returnStudents(ids: [String]) -> AnyPublisher<Void, Error> {
        dataSource.returnStudents(ids: ids)
    }

    public func getEarlyReturn(floor: Int, status: String) -> AnyPublisher<[EarlyReturnEntity], Error> {
        dataSource.getEarlyReturn(floor: floor, status: status)
            .map { $0.map { $0.toEntity() } }
            .eraseToAnyPublisher()
    }
}
