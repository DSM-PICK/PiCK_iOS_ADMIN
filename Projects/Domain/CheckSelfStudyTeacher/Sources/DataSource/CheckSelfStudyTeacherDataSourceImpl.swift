import Foundation
import Combine
import BaseDomain
import Core

public class CheckSelfStudyTeacherDataSourceImpl: BaseRemoteDataSource<CheckSelfStudyTeacherAPI>, CheckSelfStudyTeacherDataSource {

    public func getSelfStudyTeacher(date: String) -> AnyPublisher<[SelfStudyTeacherResponseDTO], Error> {
        request(.getSelfStudyTeacher(date: date))
            .tryMap { response in
                try response.map([SelfStudyTeacherResponseDTO].self)
            }
            .eraseToAnyPublisher()
    }
}
