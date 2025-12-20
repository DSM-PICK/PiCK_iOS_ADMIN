import Foundation
import AllTabDomainInterface
import Combine

public class AllTabRepositoryImpl: AllTabRepository {
    private let dataSource: AllTabDataSource

    public init(dataSource: AllTabDataSource) {
        self.dataSource = dataSource
    }

    public func getMyName() -> AnyPublisher<MyNameEntity, Error> {
        dataSource.getMyName()
            .map { $0.toEntity() }
            .eraseToAnyPublisher()
    }
}

extension MyNameResponseDTO {
    func toEntity() -> MyNameEntity {
        .init(name: name, grade: grade, classNum: classNum)
    }
}
