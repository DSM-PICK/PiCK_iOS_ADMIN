import Foundation
import Combine
import BaseDomain
import Core

public final class SchoolMealRemoteDataSourceImpl: BaseRemoteDataSource<SchoolMealAPI>, SchoolMealRemoteDataSource {

    public func fetchSchoolMeal(date: String) -> AnyPublisher<SchoolMealDTO, Error> {
        request(.fetchSchoolMeal(date: date))
            .tryMap { response in
                try response.map(SchoolMealDTO.self)
            }
            .eraseToAnyPublisher()
    }
}
