import Foundation
import Combine
import BaseDomain
import Core
import Moya
import OutListDomainInterface

public final class OutListDataSourceImpl: BaseRemoteDataSource<OutListAPI>, OutListDataSource {
    public func getOutList(floor: Int) -> AnyPublisher<[OutListResponseDTO], Error> {
        request(.getOutList(floor: floor))
            .tryMap { response in
                try response.map([OutListResponseDTO].self)
            }
            .eraseToAnyPublisher()
    }
}
