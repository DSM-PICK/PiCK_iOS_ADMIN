import Foundation
import Combine
import PlanDomainInterface

public final class PlanRepositoryImpl: PlanRepository {
    private let remoteDataSource: PlanRemoteDataSource

    public init(remoteDataSource: PlanRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    public func fetchAcademicScheduleByDate(date: String) -> AnyPublisher<AcademicScheduleEntity, Error> {
        remoteDataSource.fetchAcademicScheduleByDate(date: date)
            .map { dtoArray in
                dtoArray.map { dto in
                    AcademicScheduleEntityElement(
                        id: UUID(uuidString: dto.id) ?? UUID(),
                        eventName: dto.eventName,
                        month: dto.month,
                        day: dto.day,
                        dayName: dto.dayName
                    )
                }
            }
            .eraseToAnyPublisher()
    }

    public func fetchMonthAcademicSchedule(year: String, month: String) -> AnyPublisher<AcademicScheduleEntity, Error> {
        remoteDataSource.fetchMonthAcademicSchedule(year: year, month: month)
            .map { dtoArray in
                dtoArray.map { dto in
                    AcademicScheduleEntityElement(
                        id: UUID(uuidString: dto.id) ?? UUID(),
                        eventName: dto.eventName,
                        month: dto.month,
                        day: dto.day,
                        dayName: dto.dayName
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
