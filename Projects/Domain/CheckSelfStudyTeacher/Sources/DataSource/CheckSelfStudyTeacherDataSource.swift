import Foundation

public protocol CheckSelfStudyTeacherDataSource {
    func getSelfStudyTeacher(date: String) async throws -> [SelfStudyTeacherResponseDTO]
}
