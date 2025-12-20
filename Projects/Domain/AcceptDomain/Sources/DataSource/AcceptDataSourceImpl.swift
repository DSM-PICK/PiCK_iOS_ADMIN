import Foundation
import BaseDomain
import Core
import Combine

public final class AcceptDataSourceImpl: BaseRemoteDataSource<AcceptAPI>, AcceptDataSource {

    public func getApplicationsByGrade(grade: Int, classNum: Int) -> AnyPublisher<ApplicationListResponseDTO, Error> {
        request(.getApplicationsByGrade(grade: grade, classNum: classNum))
            .tryMap { response in
                try response.map(ApplicationListResponseDTO.self)
            }
            .eraseToAnyPublisher()
    }

    public func getApplicationsByFloor(floor: Int) -> AnyPublisher<ClassroomMoveListResponseDTO, Error> {
        request(.getApplicationsByFloor(floor: floor))
            .tryMap { response in
                try response.map(ClassroomMoveListResponseDTO.self)
            }
            .eraseToAnyPublisher()
    }

    public func getClassroomMovesByGrade(grade: Int, classNum: Int) -> AnyPublisher<ClassroomMoveListResponseDTO, Error> {
        request(.getClassroomMovesByGrade(grade: grade, classNum: classNum))
            .tryMap { response in
                try response.map(ClassroomMoveListResponseDTO.self)
            }
            .eraseToAnyPublisher()
    }

    public func getEarlyReturnByGrade(grade: Int, classNum: Int) -> AnyPublisher<EarlyReturnListResponseDTO, Error> {
        request(.getEarlyReturnByGrade(grade: grade, classNum: classNum))
            .tryMap { response in
                try response.map(EarlyReturnListResponseDTO.self)
            }
            .eraseToAnyPublisher()
    }

    public func updateApplicationStatus(status: String, idList: [String]) -> AnyPublisher<Void, Error> {
        request(.updateApplicationStatus(status: status, idList: idList))
            .tryMap { _ in () }
            .eraseToAnyPublisher()
    }

    public func updateClassroomMoveStatus(status: String, idList: [String]) -> AnyPublisher<Void, Error> {
        request(.updateClassroomMoveStatus(status: status, idList: idList))
            .tryMap { _ in () }
            .eraseToAnyPublisher()
    }

    public func updateEarlyReturnStatus(status: String, idList: [String]) -> AnyPublisher<Void, Error> {
        request(.updateEarlyReturnStatus(status: status, idList: idList))
            .tryMap { _ in () }
            .eraseToAnyPublisher()
    }
}
