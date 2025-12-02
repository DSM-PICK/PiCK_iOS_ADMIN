import Foundation

public protocol CheckSelfStudyTeacherDomainInterface {}

// MARK: - Entity
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

// MARK: - Repository
public protocol CheckSelfStudyTeacherRepository {
    func getSelfStudyTeacher(date: String) async throws -> [SelfStudyTeacherEntity]
}

// MARK: - UseCase
public protocol FetchSelfStudyTeacherUseCaseProtocol {
    func execute(date: String) async throws -> [SelfStudyTeacherEntity]
}
