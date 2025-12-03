import Foundation
import OutListDomainInterface
import Combine

public class GetOutListUseCaseImpl: GetOutListUseCase {
    private let repository: OutListRepository

    public init(repository: OutListRepository) {
        self.repository = repository
    }

    public func execute(floor: Int) -> AnyPublisher<[OutListResponseDTO], Error> {
        repository.getOutList(floor: floor)
    }
}
