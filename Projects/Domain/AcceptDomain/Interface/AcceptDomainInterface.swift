import Foundation

public protocol AcceptRepository {
    func getApplicationsByGrade(grade: Int, classNum: Int) async throws -> [ApplicationEntity]
    func getApplicationsByFloor(floor: Int) async throws -> [ClassroomMoveEntity]
    func getClassroomMovesByGrade(grade: Int, classNum: Int) async throws -> [ClassroomMoveEntity]
    func getEarlyReturnByGrade(grade: Int, classNum: Int) async throws -> [EarlyReturnEntity]
    func updateApplicationStatus(status: String, idList: [String]) async throws
    func updateClassroomMoveStatus(status: String, idList: [String]) async throws
    func updateEarlyReturnStatus(status: String, idList: [String]) async throws
}

public struct ApplicationEntity: Equatable, Identifiable {
    public let id: String
    public let userId: String
    public let userName: String
    public let start: String
    public let end: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let reason: String

    public init(
        id: String,
        userId: String,
        userName: String,
        start: String,
        end: String,
        grade: Int,
        classNum: Int,
        num: Int,
        reason: String
    ) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.start = start
        self.end = end
        self.grade = grade
        self.classNum = classNum
        self.num = num
        self.reason = reason
    }
}

public struct ClassroomMoveEntity: Equatable, Identifiable {
    public let id: String
    public let userId: String
    public let userName: String
    public let classroomName: String
    public let move: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let start: Int
    public let end: Int

    public init(
        id: String,
        userId: String,
        userName: String,
        classroomName: String,
        move: String,
        grade: Int,
        classNum: Int,
        num: Int,
        start: Int,
        end: Int
    ) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.classroomName = classroomName
        self.move = move
        self.grade = grade
        self.classNum = classNum
        self.num = num
        self.start = start
        self.end = end
    }
}

public struct EarlyReturnEntity: Equatable, Identifiable {
    public let id: String
    public let userName: String
    public let start: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let reason: String

    public init(
        id: String,
        userName: String,
        start: String,
        grade: Int,
        classNum: Int,
        num: Int,
        reason: String
    ) {
        self.id = id
        self.userName = userName
        self.start = start
        self.grade = grade
        self.classNum = classNum
        self.num = num
        self.reason = reason
    }
}

public protocol AcceptDomainInterface {}
