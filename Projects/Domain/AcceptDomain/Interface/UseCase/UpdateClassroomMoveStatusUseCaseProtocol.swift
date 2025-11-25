import Foundation

public protocol UpdateClassroomMoveStatusUseCaseProtocol {
    func execute(status: String, idList: [String]) async throws
}
