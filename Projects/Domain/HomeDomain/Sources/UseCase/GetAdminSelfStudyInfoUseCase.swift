import Foundation
import HomeDomainInterface

public class GetAdminSelfStudyInfoUseCase: GetAdminSelfStudyInfoUseCaseProtocol {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }

    public func execute() async throws -> String {
        try await repository.getAdminSelfStudyInfo()
    }
}
