import Foundation

public protocol SchoolMealRepository {
    func fetchSchoolMeal(date: String) async throws -> SchoolMealEntity
}
