import Foundation
import Combine

public protocol HomeRepository {
    func getSelfStudyDirector(date: String) -> AnyPublisher<[SelfStudyDirectorEntity], Error>
    func getAdminSelfStudyInfo() -> AnyPublisher<String, Error>
}

public struct SelfStudyDirectorEntity: Equatable {
    public let floor: Int
    public let teacherName: String
    
    public init(floor: Int, teacherName: String) {
        self.floor = floor
        self.teacherName = teacherName
    }
}
