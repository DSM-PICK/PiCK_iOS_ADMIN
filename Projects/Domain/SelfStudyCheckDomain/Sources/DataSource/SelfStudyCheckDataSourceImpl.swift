import Foundation
import Combine
import BaseDomain
import Core
import SelfStudyCheckDomainInterface

public final class SelfStudyCheckDataSourceImpl: BaseRemoteDataSource<SelfStudyCheckAPI>, SelfStudyCheckDataSource {

    public func getStudentAttendance(grade: Int, classNum: Int, period: Int) -> AnyPublisher<[StudentAttendanceResponseDTO], Error> {
        request(.getStudentAttendance(grade: grade, classNum: classNum, period: period))
            .tryMap { response in
                try response.map([StudentAttendanceResponseDTO].self)
            }
            .eraseToAnyPublisher()
    }

    public func modifyAttendance(period: Int, attendances: [AttendanceUpdateRequestDTO]) -> AnyPublisher<Void, Error> {
        request(.modifyAttendance(period: period, attendances: attendances))
            .tryMap { _ in () }
            .eraseToAnyPublisher()
    }
}
