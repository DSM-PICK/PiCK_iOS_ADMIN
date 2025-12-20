import Foundation
import Combine

public protocol GetClassroomMoveByClassroomUseCase {
    func execute(grade: Int, classNum: Int) -> AnyPublisher<[ClassroomMoveListEntity], Error>
}
