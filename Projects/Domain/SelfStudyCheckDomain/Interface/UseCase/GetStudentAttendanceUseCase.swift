import Foundation

public protocol GetStudentAttendanceUseCase {
    func execute(grade: Int, classNum: Int, period: Int) async throws -> [StudentAttendanceEntity]
}
