import Foundation

public protocol GetApplicationsByFloorUseCaseProtocol {
    func execute(floor: Int) async throws -> [ClassroomMoveEntity]
}
