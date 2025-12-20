import Foundation
import AcceptDomainInterface
import Combine

public class UpdateClassroomMoveStatusUseCase: UpdateClassroomMoveStatusUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute(status: String, idList: [String]) -> AnyPublisher<Void, Error> {
        repository.updateClassroomMoveStatus(status: status, idList: idList)
    }
}
