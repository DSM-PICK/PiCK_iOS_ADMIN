import Foundation
import SchoolMealDomainInterface

public struct SchoolMealDTO: Decodable {
    public let date: String
    public let meals: SchoolMealDTOElement

    enum CodingKeys: String, CodingKey {
        case date
        case meals = "meal_list"
    }
}

extension SchoolMealDTO {
    func toDomain() -> SchoolMealEntity {
        return .init(meals: meals.toDomain())
    }
}

public struct SchoolMealDTOElement: Decodable {
   public let breakfast, lunch, dinner: MealDTOElement
}

extension SchoolMealDTOElement {
    func toDomain() -> SchoolMealEntityElement {
        return .init(
            mealBundle: [
                ("조식", breakfast.toDomain()),
                ("중식", lunch.toDomain()),
                ("석식", dinner.toDomain())
            ]
        )
    }
}

extension MealDTOElement {
    func toDomain() -> MealEntityElement {
        return .init(
            menu: menu,
            kcal: cal
        )
    }
}

public struct MealDTOElement: Decodable {
    public let menu: [String]
    public let cal: String
}
