import Foundation

public protocol GetClassroomMoveByClassroom {
    func execute(grade: Int, classNum: Int) async throws -> [ClassroomMoveListEntity]
}
