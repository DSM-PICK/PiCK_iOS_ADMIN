import Foundation

public protocol HomeRepository {
    func getSelfStudyDirector() async throws -> [SelfStudyDirectorEntity]
}

public protocol GetSelfStudyDirectorUseCaseProtocol {
    func execute() async throws -> [SelfStudyDirectorEntity]
}

public struct SelfStudyDirectorEntity: Equatable {
    public let floor: Int
    public let teacherName: String
}
