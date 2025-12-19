import Foundation
import OutListDomainInterface

public class GetEarlyReturnUseCaseImpl: GetEarlyReturnUseCase {
    private let repository: OutListRepository

    public init(repository: OutListRepository) {
        self.repository = repository
    }

    public func execute(floor: Int, status: String) async throws -> [EarlyReturnEntity] {
        try await repository.getEarlyReturn(floor: floor, status: status)
    }
}
