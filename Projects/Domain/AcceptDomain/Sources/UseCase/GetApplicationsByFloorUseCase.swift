import Foundation
import AcceptDomainInterface
import Combine

public class GetApplicationsByFloorUseCase: GetApplicationsByFloorUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute(floor: Int) -> AnyPublisher<[ClassroomMoveEntity], Error> {
        repository.getApplicationsByFloor(floor: floor)
    }
}
