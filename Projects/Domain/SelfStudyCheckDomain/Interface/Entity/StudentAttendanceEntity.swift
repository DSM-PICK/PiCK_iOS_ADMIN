import Foundation

public struct StudentAttendanceEntity: Equatable, Identifiable {
    public let id: String
    public let userName: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let status: String
    public let classroomName: String

    public init(
        id: String,
        userName: String,
        grade: Int,
        classNum: Int,
        num: Int,
        status: String,
        classroomName: String
    ) {
        self.id = id
        self.userName = userName
        self.grade = grade
        self.classNum = classNum
        self.num = num
        self.status = status
        self.classroomName = classroomName
    }
}
