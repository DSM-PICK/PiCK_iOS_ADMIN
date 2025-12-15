import Foundation

public protocol GetClassroomMoveByFloorUseCase {
    func execute(floor: Int) async throws -> [ClassroomMoveListEntity]
}
