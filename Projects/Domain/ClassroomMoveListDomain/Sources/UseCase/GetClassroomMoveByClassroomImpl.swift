import Foundation
import Combine
import ClassroomMoveListDomainInterface

public class GetClassroomMoveByClassroomImpl: GetClassroomMoveByClassroomUseCase {
    private let repository: ClassroomMoveListRepository

    public init(repository: ClassroomMoveListRepository) {
        self.repository = repository
    }

    public func execute(grade: Int, classNum: Int) -> AnyPublisher<[ClassroomMoveListEntity], Error> {
        repository.getClassroomMoveByClassroom(grade: grade, classNum: classNum)
    }
}
