import Foundation
import AcceptDomainInterface

public class AcceptRepositoryImpl: AcceptRepository {
    private let dataSource: AcceptDataSource

    public init(dataSource: AcceptDataSource) {
        self.dataSource = dataSource
    }

    public func getApplicationsByGrade(grade: Int, classNum: Int) async throws -> [ApplicationEntity] {
        try await dataSource.getApplicationsByGrade(grade: grade, classNum: classNum).map { $0.toEntity() }
    }
}

extension ApplicationResponseDTO {
    func toEntity() -> ApplicationEntity {
        .init(
            id: id,
            userId: userId,
            userName: userName,
            start: start,
            end: end,
            grade: grade,
            classNum: classNum,
            num: num,
            reason: reason
        )
    }
}
