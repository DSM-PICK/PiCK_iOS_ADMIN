import Foundation
import AcceptDomainInterface

public class GetClassroomMovesUseCase: GetClassroomMovesUseCaseProtocol {
    private let repository: AcceptRepository

    public init(repository: AcceptRepository) {
        self.repository = repository
    }

    public func execute(grade: Int, classNum: Int) async throws -> [ClassroomMoveEntity] {
        try await repository.getClassroomMovesByGrade(grade: grade, classNum: classNum)
    }
}
