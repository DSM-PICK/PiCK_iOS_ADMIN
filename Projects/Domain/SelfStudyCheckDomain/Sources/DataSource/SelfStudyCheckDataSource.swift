import SelfStudyCheckDomainInterface

public protocol SelfStudyCheckDataSource {
    func getStudentAttendance(grade: Int, classNum: Int, period: Int) async throws -> [StudentAttendanceResponseDTO]
}
