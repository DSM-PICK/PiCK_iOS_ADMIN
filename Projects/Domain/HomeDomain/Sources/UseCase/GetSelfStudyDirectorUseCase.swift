import Foundation
import HomeDomainInterface

public class GetSelfStudyDirectorUseCase: GetSelfStudyDirectorUseCaseProtocol {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }

    public func execute(date: String) async throws -> [SelfStudyDirectorEntity] {
        try await repository.getSelfStudyDirector(date: date)
    }
}
