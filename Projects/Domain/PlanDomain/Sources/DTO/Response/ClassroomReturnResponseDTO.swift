import Foundation
import PlanDomainInterface

public struct ClassroomReturnResponseDTO: Decodable {
    let id: String
    let userName: String
    let grade: Int
    let classNum: Int
    let number: Int
    let floor: Int
    let classroom: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
        case grade
        case classNum = "class_num"
        case number = "num"
        case floor
        case classroom
    }
}

extension ClassroomReturnResponseDTO {
    func toDomain() -> ClassroomReturnEntity {
        ClassroomReturnEntity(
            id: id,
            userName: userName,
            grade: grade,
            classNum: classNum,
            number: number,
            floor: floor,
            classroom: classroom
        )
    }
}
