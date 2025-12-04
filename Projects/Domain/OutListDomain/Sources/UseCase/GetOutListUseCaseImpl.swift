import Foundation
import OutListDomainInterface

public class GetOutListUseCaseImpl: GetOutListUseCase {
    private let repository: OutListRepository

    public init(repository: OutListRepository) {
        self.repository = repository
    }

    public func execute(floor: Int) async throws -> [OutListEntity] {
        try await repository.getOutList(floor: floor)
    }
}
