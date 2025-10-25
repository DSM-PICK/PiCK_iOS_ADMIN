import Foundation

public struct MyNameResponseDTO: Decodable {
    public let name: String
    public let grade: Int
    public let classNum: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case grade
        case classNum
    }
    
    public init(name: String, grade: Int, classNum: Int) {
        self.name = name
        self.grade = grade
        self.classNum = classNum
    }
}
