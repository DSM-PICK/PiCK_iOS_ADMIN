import Foundation

public struct OutingHistoryEntity: Equatable, Identifiable {
    public let id: String
    public let userName: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let applicationCnt: Int
    public let earlyReturnCnt: Int

    public init(
        id: String,
        userName: String,
        grade: Int,
        classNum: Int,
        num: Int,
        applicationCnt: Int,
        earlyReturnCnt: Int
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
