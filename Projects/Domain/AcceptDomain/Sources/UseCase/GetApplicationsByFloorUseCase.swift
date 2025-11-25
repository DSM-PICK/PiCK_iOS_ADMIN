import Foundation
import AcceptDomainInterface
import Combine

public class GetApplicationsByFloorUseCase: GetApplicationsByFloorUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute(floor: Int) -> AnyPublisher<[ClassroomMoveEntity], Error> {
        Future { promise in
            Task {
                do {
                    let classroomMoves = try await self.repository.getApplicationsByFloor(floor: floor)
                    promise(.success(classroomMoves))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
