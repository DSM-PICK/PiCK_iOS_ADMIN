import Foundation
import Combine
import SchoolMealDomainInterface

public struct FetchSchoolMealUseCase: FetchSchoolMealUseCaseProtocol {
    private let repository: SchoolMealRepository

    public init(repository: SchoolMealRepository) {
        self.repository = repository
    }

    public func execute(date: String) -> AnyPublisher<SchoolMealEntity, Error> {
        repository.fetchSchoolMeal(date: date)
    }
}
