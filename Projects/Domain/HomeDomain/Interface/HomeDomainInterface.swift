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

public struct GetSelfStudyAndClassroomEntity: Equatable {
    public let selfStudyFloor: Int
    public let grade: Int
    public let classNum: Int

    public init(selfStudyFloor: Int, grade: Int, classNum: Int) {
        self.selfStudyFloor = selfStudyFloor
        self.grade = grade
        self.classNum = classNum
    }
}
