import Foundation
import AcceptDomainInterface

public class UpdateClassroomMoveStatusUseCase: UpdateClassroomMoveStatusUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute(status: String, idList: [String]) async throws {
        try await repository.updateClassroomMoveStatus(status: status, idList: idList)
    }
}
