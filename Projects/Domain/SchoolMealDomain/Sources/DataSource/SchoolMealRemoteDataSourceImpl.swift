import Foundation
import Combine
import Moya
import CombineMoya

public final class SchoolMealRemoteDataSourceImpl: SchoolMealRemoteDataSource {
    private let provider = MoyaProvider<SchoolMealAPI>()

    public init() {}

    public func fetchSchoolMeal(date: String) -> AnyPublisher<SchoolMealDTO, Error> {
        return provider.requestPublisher(.fetchSchoolMeal(date: date))
            .tryMap { response in
                let neisResponse = try response.map(NEISMealResponse.self)
                return SchoolMealDTO(from: neisResponse, date: date)
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
