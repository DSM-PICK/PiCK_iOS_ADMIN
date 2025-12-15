import Foundation

public struct StudentAttendanceResponseDTO: Decodable {
    public let id: String
    public let userName: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let status: String
    public let classroomName: String

    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
        case grade
        case classNum = "class_num"
        case num
        case status
        case classroomName = "classroom_name"
    }

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

extension StudentAttendanceResponseDTO {
    public func toEntity() -> StudentAttendanceEntity {
        .init(
            id: id,
            userName: userName,
            grade: grade,
            classNum: classNum,
            num: num,
            status: status,
            classroomName: classroomName
        )
    }
}
