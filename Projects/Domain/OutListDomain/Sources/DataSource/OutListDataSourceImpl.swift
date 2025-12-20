import Foundation
import Combine
import BaseDomain
import Core
import OutListDomainInterface

public final class OutListDataSourceImpl: BaseRemoteDataSource<OutListAPI>, OutListDataSource {

    public func getOutList(floor: Int) -> AnyPublisher<[OutListResponseDTO], Error> {
        request(.getOutList(floor: floor))
            .tryMap { response in
                try response.map([OutListResponseDTO].self)
            }
            .eraseToAnyPublisher()
    }

    public func returnStudents(ids: [String]) -> AnyPublisher<Void, Error> {
        request(.returnStudents(ids: ids))
            .tryMap { _ in () }
            .eraseToAnyPublisher()
    }

    public func getEarlyReturn(floor: Int, status: String) -> AnyPublisher<[EarlyReturnResponseDTO], Error> {
        request(.earlyReturnList(floor: floor, status: status))
            .tryMap { response in
                try response.map([EarlyReturnResponseDTO].self)
            }
            .eraseToAnyPublisher()
    }
}
