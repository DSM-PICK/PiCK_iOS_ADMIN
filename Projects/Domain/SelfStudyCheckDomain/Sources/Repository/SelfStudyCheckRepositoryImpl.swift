import Foundation
import Combine
import SelfStudyCheckDomainInterface

public class SelfStudyCheckRepositoryImpl: SelfStudyCheckRepository {
    private let dataSource: SelfStudyCheckDataSource

    public init(dataSource: SelfStudyCheckDataSource) {
        self.dataSource = dataSource
    }

    public func getStudentAttendance(grade: Int, classNum: Int, period: Int) -> AnyPublisher<[StudentAttendanceEntity], Error> {
        dataSource.getStudentAttendance(grade: grade, classNum: classNum, period: period)
            .map { $0.map { $0.toEntity() } }
            .eraseToAnyPublisher()
    }

    public func modifyAttendance(period: Int, attendances: [AttendanceUpdateRequestDTO]) -> AnyPublisher<Void, Error> {
        dataSource.modifyAttendance(period: period, attendances: attendances)
    }
}
