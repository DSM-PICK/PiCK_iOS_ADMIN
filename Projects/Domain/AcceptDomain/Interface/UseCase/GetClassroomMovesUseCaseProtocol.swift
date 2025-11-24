import Foundation
import Combine

public protocol GetClassroomMovesUseCaseProtocol {
    func execute(grade: Int, classNum: Int) -> AnyPublisher<[ClassroomMoveEntity], Error>
}
