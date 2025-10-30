import Foundation
import PlanDomainInterface

public struct WeekendMealApplicationResponseDTO: Decodable {
    let id: String
    let userName: String
    let grade: Int
    let classNum: Int
    let number: Int
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
        case grade
        case classNum = "class_num"
        case number = "num"
        case status
    }
}

extension WeekendMealApplicationResponseDTO {
    func toDomain() -> WeekendMealApplicationEntity {
        WeekendMealApplicationEntity(
            id: id,
            userName: userName,
            grade: grade,
            classNum: classNum,
            number: number,
            status: status
        )
    }
}
