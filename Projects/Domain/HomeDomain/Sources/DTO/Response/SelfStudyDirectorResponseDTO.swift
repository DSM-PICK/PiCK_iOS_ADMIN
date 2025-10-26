import Foundation

public struct SelfStudyDirectorResponseDTO: Decodable {
    public let floor: Int
    public let teacherName: String
    
    enum CodingKeys: String, CodingKey {
        case floor
        case teacherName = "teacher_name"
    }
    
    public init(floor: Int, teacherName: String) {
        self.floor = floor
        self.teacherName = teacherName
    }
}
