import Foundation
import ClassroomMoveListDomainInterface

public class GetClassroomMoveByFloorUseCaseImpl: GetClassroomMoveByFloorUseCase {
    private let repository: ClassroomMoveListRepository

    public init(repository: ClassroomMoveListRepository) {
        self.repository = repository
    }

    public func execute(floor: Int) async throws -> [ClassroomMoveListEntity] {
        try await repository.getClassroomMoveByFloor(floor: floor)
    }
}
