import Foundation
import BaseDomain
import Core
import Combine

public final class AllTabDataSourceImpl: BaseRemoteDataSource<AdminAPI>, AllTabDataSource {

    public func getMyName() -> AnyPublisher<MyNameResponseDTO, Error> {
        request(.getMyName)
            .tryMap { response in
                try response.map(MyNameResponseDTO.self)
            }
            .eraseToAnyPublisher()
    }
}
