import Foundation

public protocol HomeRepository {
    func getSelfStudyDirector(date: String) async throws -> [SelfStudyDirectorEntity]
}

public struct SelfStudyDirectorEntity: Equatable {
    public let floor: Int
    public let teacherName: String
    
    public init(floor: Int, teacherName: String) {
        self.floor = floor
        self.teacherName = teacherName
    }
}
