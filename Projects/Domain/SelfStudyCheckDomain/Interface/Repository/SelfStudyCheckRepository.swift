import Foundation

public protocol SelfStudyCheckRepository {
    func getStudentAttendance(grade: Int, classNum: Int, period: Int) async throws -> [StudentAttendanceEntity]
}
