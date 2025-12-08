import Foundation

public protocol ClassroomMoveListRepository {
    func getClassroomMoveByFloor(floor: Int) async throws -> [ClassroomMoveListEntity]
    func getClassroomMoveByClassroom(grade: Int, classNum: Int) async throws -> [ClassroomMoveListEntity]
}
