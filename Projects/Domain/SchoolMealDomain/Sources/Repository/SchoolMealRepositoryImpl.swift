import Foundation
import Combine
import SchoolMealDomainInterface

public final class SchoolMealRepositoryImpl: SchoolMealRepository {
    private let remoteDataSource: SchoolMealRemoteDataSource

    public init(remoteDataSource: SchoolMealRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    public func fetchSchoolMeal(date: String) -> AnyPublisher<SchoolMealEntity, Error> {
        remoteDataSource.fetchSchoolMeal(date: date)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
