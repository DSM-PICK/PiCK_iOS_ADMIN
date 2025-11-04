import Foundation
import PlanDomainInterface

public struct FetchMonthAcademicScheduleUseCase: FetchMonthAcademicScheduleUseCaseProtocol {
    private let repository: PlanRepository
    
    public init(repository: PlanRepository) {
        self.repository = repository
    }
    
    public func execute(year: String, month: String) async throws -> AcademicScheduleEntity {
        return try await repository.fetchMonthAcademicSchedule(year: year, month: month)
    }
}
