import Foundation
import Combine
import OutListDomainInterface

public class GetOutListUseCaseImpl: GetOutListUseCase {
    private let repository: OutListRepository

    public init(repository: OutListRepository) {
        self.repository = repository
    }

    public func execute(floor: Int) -> AnyPublisher<[OutListEntity], Error> {
        repository.getOutList(floor: floor)
    }
}
