import Foundation
import SelfStudyCheckDomainInterface

public class SelfStudyCheckRepositoryImpl: SelfStudyCheckRepository {
    private let dataSource: SelfStudyCheckDataSource

    public init(dataSource: SelfStudyCheckDataSource) {
        self.dataSource = dataSource
    }

    public func getStudentAttendance(grade: Int, classNum: Int, period: Int) async throws -> [StudentAttendanceEntity] {
        try await dataSource.getStudentAttendance(grade: grade, classNum: classNum, period: period).map { $0.toEntity() }
    }
}
