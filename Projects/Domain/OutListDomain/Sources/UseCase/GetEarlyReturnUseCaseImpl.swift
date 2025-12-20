import Foundation
import Combine
import OutListDomainInterface

public class GetEarlyReturnUseCaseImpl: GetEarlyReturnUseCase {
    private let repository: OutListRepository

    public init(repository: OutListRepository) {
        self.repository = repository
    }

    public func execute(floor: Int, status: String) -> AnyPublisher<[EarlyReturnEntity], Error> {
        repository.getEarlyReturn(floor: floor, status: status)
    }
}
