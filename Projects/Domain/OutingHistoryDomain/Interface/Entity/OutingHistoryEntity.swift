import Foundation

public struct OutingHistoryEntity: Decodable {
    public let id: String
    public let userName: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let applicationCnt: String
    public let earlyReturnCnt: String

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
