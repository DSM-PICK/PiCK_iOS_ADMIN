import Foundation
import AllTabDomainInterface

public class GetMyNameUseCase: GetMyNameUseCaseProtocol {
    private let repository: AllTabRepository

    public init(repository: AllTabRepository) {
        self.repository = repository
    }

    public func execute() async throws -> MyNameEntity {
        try await repository.getMyName()
    }
}
