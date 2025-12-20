import Foundation
import Combine

public protocol SchoolMealRemoteDataSource {
    func fetchSchoolMeal(date: String) -> AnyPublisher<SchoolMealDTO, Error>
}
