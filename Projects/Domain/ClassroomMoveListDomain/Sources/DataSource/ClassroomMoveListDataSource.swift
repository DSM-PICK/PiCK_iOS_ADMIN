import Foundation
import Combine
import ClassroomMoveListDomainInterface

public protocol ClassroomMoveListDataSource {
    func getClassroomMoveByFloor(floor: Int) -> AnyPublisher<[ClassroomMoveListResponseDTO], Error>
    func getClassroomMoveByClassroom(grade: Int, classNum: Int) -> AnyPublisher<[ClassroomMoveListResponseDTO], Error>
}
