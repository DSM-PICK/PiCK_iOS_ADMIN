import Foundation
import Combine
import BaseDomain
import Core

public protocol PlanRemoteDataSource {
    func fetchAcademicScheduleByDate(date: String) -> AnyPublisher<AcademicScheduleResponseDTOArray, Error>
    func fetchMonthAcademicSchedule(year: String, month: String) -> AnyPublisher<AcademicScheduleResponseDTOArray, Error>
}

public final class PlanRemoteDataSourceImpl: BaseRemoteDataSource<PlanAPI>, PlanRemoteDataSource {

    public func fetchAcademicScheduleByDate(date: String) -> AnyPublisher<AcademicScheduleResponseDTOArray, Error> {
        request(.fetchAcademicScheduleByDate(date: date))
            .tryMap { response in
                try response.map(AcademicScheduleResponseDTOArray.self)
            }
            .eraseToAnyPublisher()
    }

    public func fetchMonthAcademicSchedule(year: String, month: String) -> AnyPublisher<AcademicScheduleResponseDTOArray, Error> {
        request(.fetchMonthAcademicSchedule(year: year, month: month))
            .tryMap { response in
                try response.map(AcademicScheduleResponseDTOArray.self)
            }
            .eraseToAnyPublisher()
    }
}
