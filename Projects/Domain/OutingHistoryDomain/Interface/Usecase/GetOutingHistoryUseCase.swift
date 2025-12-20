import Foundation
import Combine

public protocol GetOutingHistoryUseCase {
    func execute() -> AnyPublisher<[OutingHistoryEntity], Error>
}
