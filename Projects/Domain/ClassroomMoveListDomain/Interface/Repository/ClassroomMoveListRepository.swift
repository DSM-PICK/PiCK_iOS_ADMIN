import Foundation
import Combine

public protocol ClassroomMoveListRepository {
    func getClassroomMoveByFloor(floor: Int) -> AnyPublisher<[ClassroomMoveListEntity], Error>
    func getClassroomMoveByClassroom(grade: Int, classNum: Int) -> AnyPublisher<[ClassroomMoveListEntity], Error>
}
