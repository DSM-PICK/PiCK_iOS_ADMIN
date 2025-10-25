import Foundation
import AllTabDomainInterface

public class GetSelfStudyDirectorUseCase: GetSelfStudyDirectorUseCaseProtocol {
    private let repository: AllTabRepository

    public init(repository: AllTabRepository) {
        self.repository = repository
    }

    public func execute(date: String) async throws -> [SelfStudyDirectorEntity] {
        try await repository.getSelfStudyDirector(date: date)
    }
}
