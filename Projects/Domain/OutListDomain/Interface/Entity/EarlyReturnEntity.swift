import Foundation

public struct EarlyReturnEntity: Equatable {
    public let userId: String
    public let userName: String
    public let start: String
    public let end: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let reason: String
    
    public init(
        userId: String,
        userName: String,
        start: String,
        end: String,
        grade: Int,
        classNum: Int,
        num: Int,
        reason: String
    ) {
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
