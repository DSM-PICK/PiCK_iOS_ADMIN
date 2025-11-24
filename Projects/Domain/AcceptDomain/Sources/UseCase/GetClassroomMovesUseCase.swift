import Foundation
import AcceptDomainInterface
import Combine

public class GetClassroomMovesUseCase: GetClassroomMovesUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute(grade: Int, classNum: Int) -> AnyPublisher<[ClassroomMoveEntity], Error> {
        Future { promise in
            Task {
                do {
                    let classroomMoves = try await self.repository.getClassroomMovesByGrade(grade: grade, classNum: classNum)
                    promise(.success(classroomMoves))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
