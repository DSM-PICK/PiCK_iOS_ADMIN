import Foundation
import ClassroomMoveListDomainInterface

public class GetClassroomMoveByClassroomImpl: GetClassroomMoveByClassroom {
    private let repository: ClassroomMoveListRepository

    public init(repository: ClassroomMoveListRepository) {
        self.repository = repository
    }

    public func execute(grade: Int, classNum: Int) async throws -> [ClassroomMoveListEntity] {
        try await repository.getClassroomMoveByClassroom(grade: grade, classNum: classNum)
    }
}
