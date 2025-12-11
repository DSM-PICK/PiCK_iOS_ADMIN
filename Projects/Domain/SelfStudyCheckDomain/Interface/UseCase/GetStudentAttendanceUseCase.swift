import Foundation
import Combine

public protocol GetStudentAttendanceUseCase {
    func execute(grade: Int, classNum: Int, period: Int) -> AnyPublisher<[StudentAttendanceEntity], Error>
}
