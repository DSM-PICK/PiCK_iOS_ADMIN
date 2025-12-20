import Foundation
import Combine

public protocol AcceptDataSource {
    func getApplicationsByGrade(grade: Int, classNum: Int) -> AnyPublisher<ApplicationListResponseDTO, Error>
    func getApplicationsByFloor(floor: Int) -> AnyPublisher<ClassroomMoveListResponseDTO, Error>
    func getClassroomMovesByGrade(grade: Int, classNum: Int) -> AnyPublisher<ClassroomMoveListResponseDTO, Error>
    func getEarlyReturnByGrade(grade: Int, classNum: Int) -> AnyPublisher<EarlyReturnListResponseDTO, Error>
    func updateApplicationStatus(status: String, idList: [String]) -> AnyPublisher<Void, Error>
    func updateClassroomMoveStatus(status: String, idList: [String]) -> AnyPublisher<Void, Error>
    func updateEarlyReturnStatus(status: String, idList: [String]) -> AnyPublisher<Void, Error>
}
