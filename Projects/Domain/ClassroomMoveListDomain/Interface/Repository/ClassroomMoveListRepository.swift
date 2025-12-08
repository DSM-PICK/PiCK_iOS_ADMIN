import Foundation

public protocol ClassroomMoveListRepository {
    func getClassroomMoveByFloor(floor: Int) async throws -> [ClassroomMoveListEntity]
}
