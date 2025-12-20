import Foundation
import Combine

public protocol GetClassroomMoveByFloorUseCase {
    func execute(floor: Int) -> AnyPublisher<[ClassroomMoveListEntity], Error>
}
