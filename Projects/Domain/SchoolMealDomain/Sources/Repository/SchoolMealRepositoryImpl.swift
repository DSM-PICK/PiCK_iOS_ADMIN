import Foundation
import SchoolMealDomainInterface

public final class SchoolMealRepositoryImpl: SchoolMealRepository {
    private let remoteDataSource: SchoolMealRemoteDataSource
    
    public init(remoteDataSource: SchoolMealRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    public func fetchSchoolMeal(date: String) async throws -> SchoolMealEntity {
        let dto = try await remoteDataSource.fetchSchoolMeal(date: date)
        return dto.toDomain()
    }
}
