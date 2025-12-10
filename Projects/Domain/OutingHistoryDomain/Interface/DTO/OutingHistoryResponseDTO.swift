import Foundation

public struct OutingHistoryResponseDTO: Decodable {
    public let id: String
    public let userName: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let applicationCnt: String
    public let earlyReturnCnt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
        case grade
        case classNum = "class_num"
        case num
        case applicationCnt = "application_cnt"
        case earlyReturnCnt = "early_return_cnt"
    }

    public init(
        id: String,
        userName: String,
        grade: Int,
        classNum: Int,
        num: Int,
        applicationCnt: String,
        earlyReturnCnt: String
    ) {
        self.id = id
        self.userName = userName
        self.grade = grade
        self.classNum = classNum
        self.num = num
        self.applicationCnt = applicationCnt
        self.earlyReturnCnt = earlyReturnCnt
    }
}

extension OutingHistoryResponseDTO {
    public func toEntity() -> OutingHistoryEntity {
        .init(
            id: id,
            userName: userName,
            grade: grade,
            classNum: classNum,
            num: num,
            applicationCnt: applicationCnt,
            earlyReturnCnt: earlyReturnCnt
        )
    }
}
