import Foundation
import Combine
import OutListDomainInterface

public protocol OutListDataSource {
    func getOutList(floor: Int) -> AnyPublisher<[OutListResponseDTO], Error>
    func returnStudents(ids: [String]) -> AnyPublisher<Void, Error>
    func getEarlyReturn(floor: Int, status: String) -> AnyPublisher<[EarlyReturnResponseDTO], Error>
}
