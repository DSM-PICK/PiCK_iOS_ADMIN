import Foundation
import HomeDomainInterface

class GetSelfStudyDirectorUseCase: GetSelfStudyDirectorUseCaseProtocol {
    private let repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
    }

    func execute() async throws -> [SelfStudyDirectorEntity] {
        try await repository.getSelfStudyDirector()
    }
}
