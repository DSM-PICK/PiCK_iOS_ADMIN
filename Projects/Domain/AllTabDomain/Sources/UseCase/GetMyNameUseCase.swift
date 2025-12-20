import Foundation
import AllTabDomainInterface
import Combine

public class GetMyNameUseCase: GetMyNameUseCaseProtocol {
    private let repository: AllTabRepository

    public init(repository: AllTabRepository) {
        self.repository = repository
    }

    public func execute() -> AnyPublisher<MyNameEntity, Error> {
        repository.getMyName()
    }
}
