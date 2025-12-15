import Foundation
import Combine

public protocol SelfStudyCheckRepository {
    func getStudentAttendance(grade: Int, classNum: Int, period: Int) -> AnyPublisher<[StudentAttendanceEntity], Error>
    func modifyAttendance(period: Int, attendances: [AttendanceUpdateRequestDTO]) -> AnyPublisher<Void, Error>
}
