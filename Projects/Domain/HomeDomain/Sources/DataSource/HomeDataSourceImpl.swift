import HomeDomainInterface
import Foundation
import BaseDomain
import Combine

public final class HomeDataSourceImpl: BaseRemoteDataSource<MainAPI>, HomeDataSource {
    public func getSelfStudyDirector(date: String) -> AnyPublisher<[SelfStudyDirectorResponseDTO], Error> {
        request(.getSelfStudyDirector(date: date))
            .tryMap { try $0.map([SelfStudyDirectorResponseDTO].self) }
            .eraseToAnyPublisher()
    }
    
    public func getAdminSelfStudyInfo() -> AnyPublisher<String, Error> {
        requestText(.getAdminSelfStudyInfo)
    }

    public func getSelfStudyAndClassroom() -> AnyPublisher<GetSelfStudyAndClassroomResponseDTO, Error> {
        request(.getSelfStudyAndClassroom)
            .tryMap { try $0.map(GetSelfStudyAndClassroomResponseDTO.self) }
            .eraseToAnyPublisher()
    }
}
