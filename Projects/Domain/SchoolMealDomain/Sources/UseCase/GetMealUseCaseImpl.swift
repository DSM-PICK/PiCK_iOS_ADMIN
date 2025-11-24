import Foundation
import SchoolMealDomainInterface

public struct GetMealUseCaseImpl: GetMealUseCaseProtocol {
    private let repository: SchoolMealRepository
    
    public init(repository: SchoolMealRepository) {
        self.repository = repository
    }
    
    public func execute(date: String) async throws -> SchoolMealEntity {
        return try await repository.fetchSchoolMeal(date: date)
    }
}
