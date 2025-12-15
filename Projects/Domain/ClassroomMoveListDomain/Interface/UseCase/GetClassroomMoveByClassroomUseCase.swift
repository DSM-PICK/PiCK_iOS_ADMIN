import Foundation

public protocol GetClassroomMoveByClassroomUseCase {
    func execute(grade: Int, classNum: Int) async throws -> [ClassroomMoveListEntity]
}
