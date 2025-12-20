import Foundation
import Combine

public protocol FetchSchoolMealUseCaseProtocol {
    func execute(date: String) -> AnyPublisher<SchoolMealEntity, Error>
}
