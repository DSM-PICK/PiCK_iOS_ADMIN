import Foundation
import Combine

public protocol SchoolMealRepository {
    func fetchSchoolMeal(date: String) -> AnyPublisher<SchoolMealEntity, Error>
}
