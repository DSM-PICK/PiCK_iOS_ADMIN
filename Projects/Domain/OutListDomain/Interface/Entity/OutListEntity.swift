import Foundation

public struct OutListEntity: Equatable, Identifiable {
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
