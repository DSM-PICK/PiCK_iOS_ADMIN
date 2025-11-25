import Foundation
import AcceptDomainInterface

public class GetApplicationsByFloorUseCase: GetApplicationsByFloorUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute(floor: Int) async throws -> [ClassroomMoveEntity] {
        try await repository.getApplicationsByFloor(floor: floor)
    }
}
