import Foundation

public struct EarlyReturnResponseDTO: Decodable {
    public let id: String
    public let userName: String
    public let start: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let reason: String

    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
        case start
        case grade
        case classNum = "class_num"
        case num
        case reason
    }

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

public typealias EarlyReturnListResponseDTO = [EarlyReturnResponseDTO]
