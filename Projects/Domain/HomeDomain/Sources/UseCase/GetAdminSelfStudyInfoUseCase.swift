import Foundation
import HomeDomainInterface
import Combine

public class GetAdminSelfStudyInfoUseCase: GetAdminSelfStudyInfoUseCaseProtocol {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }

    public func execute() -> AnyPublisher<String, Error> {
        repository.getAdminSelfStudyInfo()
    }
}
