import Foundation

public struct SelfStudyDirectorResponseDTO: Decodable {
    public let floor: Int
    public let teacherName: String
    
    public init(floor: Int, teacherName: String) {
        self.floor = floor
        self.teacherName = teacherName
    }
}
