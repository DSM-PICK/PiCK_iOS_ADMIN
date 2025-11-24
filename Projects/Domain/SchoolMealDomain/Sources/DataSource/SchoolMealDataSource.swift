import Foundation
import Combine

public protocol SchoolMealRemoteDataSource {
    func fetchSchoolMeal(date: String) async throws -> SchoolMealDTO
}
