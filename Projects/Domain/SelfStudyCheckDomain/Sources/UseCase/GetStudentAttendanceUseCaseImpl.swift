import Foundation
import SelfStudyCheckDomainInterface

public class GetStudentAttendanceUseCaseImpl: GetStudentAttendanceUseCase {
    private let repository: SelfStudyCheckRepository

    public init(repository: SelfStudyCheckRepository) {
        self.repository = repository
    }

    public func execute(grade: Int, classNum: Int, period: Int) async throws -> [StudentAttendanceEntity] {
        try await repository.getStudentAttendance(grade: grade, classNum: classNum, period: period)
    }
}
