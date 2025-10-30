import Foundation
import PlanDomainInterface

public struct WeekendMealPeriodResponseDTO: Decodable {
    let id: String
    let startDate: String
    let endDate: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case startDate = "start_date"
        case endDate = "end_date"
        case status
    }
}

extension WeekendMealPeriodResponseDTO {
    func toDomain() -> WeekendMealPeriodEntity {
        WeekendMealPeriodEntity(
            id: id,
            startDate: startDate,
            endDate: endDate,
            status: status
        )
    }
}
