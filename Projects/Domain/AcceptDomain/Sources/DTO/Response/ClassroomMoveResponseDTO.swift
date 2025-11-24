import Foundation

public struct ClassroomMoveResponseDTO: Decodable {
    public let userId: String
    public let userName: String
    public let classroomName: String
    public let move: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let start: Int
    public let end: Int

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
        case classroomName = "classroom_name"
        case move
        case grade
        case classNum = "class_num"
        case num
        case start
        case end
    }

    public init(
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

public typealias ClassroomMoveListResponseDTO = [ClassroomMoveResponseDTO]
