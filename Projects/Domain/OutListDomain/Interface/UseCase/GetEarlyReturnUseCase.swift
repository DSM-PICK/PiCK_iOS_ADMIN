import Foundation
import Combine

public protocol GetEarlyReturnUseCase {
    func execute(floor: Int, status: String) -> AnyPublisher<[EarlyReturnEntity], Error>
}
