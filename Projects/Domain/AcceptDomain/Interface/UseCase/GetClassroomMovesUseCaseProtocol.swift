import Foundation

public protocol GetClassroomMovesUseCaseProtocol {
    func execute(grade: Int, classNum: Int) async throws -> [ClassroomMoveEntity]
}
