import Foundation

public struct OutListResponseDTO: Decodable {
    public let id: String
    public let userId: String
    public let userName: String
    public let start: String
    public let end: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let reason: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case userName = "user_name"
        case start
        case end
        case grade
        case classNum = "class_num"
        case num
        case reason
    }

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
