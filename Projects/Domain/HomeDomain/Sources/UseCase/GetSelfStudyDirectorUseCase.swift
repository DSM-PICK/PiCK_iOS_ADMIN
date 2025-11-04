import Foundation
import HomeDomainInterface
import Combine

public class GetSelfStudyDirectorUseCase: GetSelfStudyDirectorUseCaseProtocol {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }

    public func execute(date: String) -> AnyPublisher<[SelfStudyDirectorEntity], Error> {
        repository.getSelfStudyDirector(date: date)
    }
}
