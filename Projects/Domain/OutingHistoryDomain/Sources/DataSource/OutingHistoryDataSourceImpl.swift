import Foundation
import Combine
import BaseDomain
import Core
import OutingHistoryDomainInterface

public final class OutingHistoryDataSourceImpl: BaseRemoteDataSource<OutingHistoryAPI>, OutingHistoryDataSource {

    public func getOutingHistory() -> AnyPublisher<[OutingHistoryResponseDTO], Error> {
        request(.getOutingHistory)
            .tryMap { response in
                try response.map([OutingHistoryResponseDTO].self)
            }
            .eraseToAnyPublisher()
    }
}
