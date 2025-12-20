import Foundation
import Combine

public protocol OutingHistoryRepository {
    func getOutingHistory() -> AnyPublisher<[OutingHistoryEntity], Error>
}
