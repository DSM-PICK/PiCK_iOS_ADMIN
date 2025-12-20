import Foundation
import Combine
import BaseDomain
import Core
import ClassroomMoveListDomainInterface

public final class ClassroomMoveListDataSourceImpl: BaseRemoteDataSource<ClassroomMoveListAPI>, ClassroomMoveListDataSource {

    public func getClassroomMoveByFloor(floor: Int) -> AnyPublisher<[ClassroomMoveListResponseDTO], Error> {
        request(.getClassroomMoveByFloor(floor: floor))
            .tryMap { response in
                try response.map([ClassroomMoveListResponseDTO].self)
            }
            .eraseToAnyPublisher()
    }

    public func getClassroomMoveByClassroom(grade: Int, classNum: Int) -> AnyPublisher<[ClassroomMoveListResponseDTO], Error> {
        request(.getClassroomMoveByClassroom(grade: grade, classNum: classNum))
            .tryMap { response in
                try response.map([ClassroomMoveListResponseDTO].self)
            }
            .eraseToAnyPublisher()
    }
}
