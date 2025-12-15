import Combine
import SelfStudyCheckDomainInterface

public protocol SelfStudyCheckDataSource {
    func getStudentAttendance(grade: Int, classNum: Int, period: Int) -> AnyPublisher<[StudentAttendanceResponseDTO], Error>
    func modifyAttendance(period: Int, attendances: [AttendanceUpdateRequestDTO]) -> AnyPublisher<Void, Error>
}
