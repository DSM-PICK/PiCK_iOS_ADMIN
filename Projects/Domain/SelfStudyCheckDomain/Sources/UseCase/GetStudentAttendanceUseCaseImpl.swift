import Foundation
import Combine
import SelfStudyCheckDomainInterface

public class GetStudentAttendanceUseCaseImpl: GetStudentAttendanceUseCase {
    private let repository: SelfStudyCheckRepository

    public init(repository: SelfStudyCheckRepository) {
        self.repository = repository
    }

    public func execute(grade: Int, classNum: Int, period: Int) -> AnyPublisher<[StudentAttendanceEntity], Error> {
        repository.getStudentAttendance(grade: grade, classNum: classNum, period: period)
    }
}
