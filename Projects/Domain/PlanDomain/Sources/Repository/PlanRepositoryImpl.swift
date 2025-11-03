import Foundation
import PlanDomainInterface

public final class PlanRepositoryImpl: PlanRepository {
    private let remoteDataSource: PlanRemoteDataSource
    
    public init(remoteDataSource: PlanRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    public func fetchAcademicScheduleByDate(date: String) async throws -> AcademicScheduleEntity {
        let dtoArray = try await remoteDataSource.fetchAcademicScheduleByDate(date: date)
        return dtoArray.map { dto in
            AcademicScheduleEntityElement(
                id: UUID(uuidString: dto.id) ?? UUID(),
                eventName: dto.eventName,
                month: dto.month,
                day: dto.day,
                dayName: dto.dayName
            )
        }
    }
    
    public func fetchMonthAcademicSchedule(year: String, month: String) async throws -> AcademicScheduleEntity {
        let dtoArray = try await remoteDataSource.fetchMonthAcademicSchedule(year: year, month: month)
        return dtoArray.map { dto in
            AcademicScheduleEntityElement(
                id: UUID(uuidString: dto.id) ?? UUID(),
                eventName: dto.eventName,
                month: dto.month,
                day: dto.day,
                dayName: dto.dayName
            )
        }
    }
}
