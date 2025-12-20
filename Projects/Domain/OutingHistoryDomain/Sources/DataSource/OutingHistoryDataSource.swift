import Foundation
import Combine
import OutingHistoryDomainInterface

public protocol OutingHistoryDataSource {
    func getOutingHistory() -> AnyPublisher<[OutingHistoryResponseDTO], Error>
}
