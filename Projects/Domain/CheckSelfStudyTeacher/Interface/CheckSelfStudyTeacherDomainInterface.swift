import Foundation
import Combine

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
    func getSelfStudyTeacher(date: String) -> AnyPublisher<[SelfStudyTeacherEntity], Error>
}

public protocol FetchSelfStudyTeacherUseCaseProtocol {
    func execute(date: String) -> AnyPublisher<[SelfStudyTeacherEntity], Error>
}
