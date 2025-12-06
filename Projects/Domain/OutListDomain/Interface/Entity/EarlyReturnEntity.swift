import Foundation

public struct EarlyReturnEntity: Equatable {
    public let id: String
    public let userName: String
    public let start: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let reason: String
    
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
