import Foundation

public struct AdminSelfStudyInfoResponseDTO: Decodable {
    public let teacher: String
    
    enum CodingKeys: String, CodingKey {
        case teacher
    }
    
    public init(teacher: String) {
        self.teacher = teacher
    }
}
