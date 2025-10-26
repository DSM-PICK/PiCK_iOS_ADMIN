import Foundation
import AllTabDomainInterface

public class AllTabRepositoryImpl: AllTabRepository {
    private let dataSource: AllTabDataSource

    public init(dataSource: AllTabDataSource) {
        self.dataSource = dataSource
    }

    public func getMyName() async throws -> MyNameEntity {
        try await dataSource.getMyName().toEntity()
    }
}

extension MyNameResponseDTO {
    func toEntity() -> MyNameEntity {
        .init(name: name, grade: grade, classNum: classNum)
    }
}
