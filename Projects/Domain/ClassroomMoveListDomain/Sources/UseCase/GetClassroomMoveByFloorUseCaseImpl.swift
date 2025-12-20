import Foundation
import Combine
import ClassroomMoveListDomainInterface

public class GetClassroomMoveByFloorUseCaseImpl: GetClassroomMoveByFloorUseCase {
    private let repository: ClassroomMoveListRepository

    public init(repository: ClassroomMoveListRepository) {
        self.repository = repository
    }

    public func execute(floor: Int) -> AnyPublisher<[ClassroomMoveListEntity], Error> {
        repository.getClassroomMoveByFloor(floor: floor)
    }
}
