import Foundation

public protocol CheckSelfStudyTeacherDomainInterface {}

public struct SelfStudyTeacherEntity: Equatable, Identifiable {
    public var id: Int { floor }
    public let floor: Int
    public let teacherName: String

    public init(
        floor: Int,
        teacherName: String
    ) {
        self.floor = floor
        self.teacherName = teacherName
    }
}

public protocol CheckSelfStudyTeacherRepository {
    func getSelfStudyTeacher(date: String) async throws -> [SelfStudyTeacherEntity]
}

public protocol FetchSelfStudyTeacherUseCaseProtocol {
    func execute(date: String) async throws -> [SelfStudyTeacherEntity]
}
