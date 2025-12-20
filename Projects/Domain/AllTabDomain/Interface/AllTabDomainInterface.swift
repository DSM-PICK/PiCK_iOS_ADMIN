import Foundation
import Combine

public protocol AllTabRepository {
    func getMyName() -> AnyPublisher<MyNameEntity, Error>
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
