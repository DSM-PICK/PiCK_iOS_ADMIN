import Foundation
import Combine

public protocol OutListRepository {
    func getOutList(floor: Int) -> AnyPublisher<[OutListEntity], Error>
    func returnStudents(ids: [String]) -> AnyPublisher<Void, Error>
    func getEarlyReturn(floor: Int, status: String) -> AnyPublisher<[EarlyReturnEntity], Error>
}
