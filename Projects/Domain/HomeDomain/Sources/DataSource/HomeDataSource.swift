import Foundation
import Combine

public protocol HomeDataSource {
    func getSelfStudyDirector(date: String) -> AnyPublisher<[SelfStudyDirectorResponseDTO], Error>
    func getAdminSelfStudyInfo() -> AnyPublisher<String, Error>
    func getSelfStudyAndClassroom() -> AnyPublisher<GetSelfStudyAndClassroomResponseDTO, Error>
}
