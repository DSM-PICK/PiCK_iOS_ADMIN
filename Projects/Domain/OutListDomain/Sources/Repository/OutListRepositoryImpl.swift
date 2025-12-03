import Foundation
import Combine
import OutListDomainInterface

public class OutListRepositoryImpl: OutListRepository {
    private let dataSource: OutListDataSource

    public init(
        dataSource: OutListDataSource
    ) {
        self.dataSource = dataSource
    }

    public func getOutList(floor: Int) -> AnyPublisher<[OutListResponseDTO], Error> {
        dataSource.getOutList(floor: floor)
            .map { response in
                return response
            }
            .eraseToAnyPublisher()
    }
}
