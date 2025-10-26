import Foundation

public protocol AllTabRepository {
    func getMyName() async throws -> MyNameEntity
}

public struct MyNameEntity: Equatable {
    public let name: String
    public let grade: Int
    public let classNum: Int
    
    public init(name: String, grade: Int, classNum: Int) {
        self.name = name
        self.grade = grade
        self.classNum = classNum
    }
}
