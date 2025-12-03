import Foundation
import CheckSelfStudyTeacherDomainInterface

public class CheckSelfStudyTeacherRepositoryImpl: CheckSelfStudyTeacherRepository {
    private let dataSource: CheckSelfStudyTeacherDataSource

    public init(dataSource: CheckSelfStudyTeacherDataSource) {
        self.dataSource = dataSource
    }

    public func getSelfStudyTeacher(date: String) async throws -> [SelfStudyTeacherEntity] {
        try await dataSource.getSelfStudyTeacher(date: date).map { $0.toEntity() }
    }
}

extension SelfStudyTeacherResponseDTO {
    func toEntity() -> SelfStudyTeacherEntity {
        .init(floor: floor, teacherName: teacherName)
    }
}
