import Foundation
import Combine
import CheckSelfStudyTeacherDomainInterface

public class CheckSelfStudyTeacherRepositoryImpl: CheckSelfStudyTeacherRepository {
    private let dataSource: CheckSelfStudyTeacherDataSource

    public init(dataSource: CheckSelfStudyTeacherDataSource) {
        self.dataSource = dataSource
    }

    public func getSelfStudyTeacher(date: String) -> AnyPublisher<[SelfStudyTeacherEntity], Error> {
        dataSource.getSelfStudyTeacher(date: date)
            .map { $0.map { $0.toEntity() } }
            .eraseToAnyPublisher()
    }
}

extension SelfStudyTeacherResponseDTO {
    func toEntity() -> SelfStudyTeacherEntity {
        .init(floor: floor, teacherName: teacherName)
    }
}
