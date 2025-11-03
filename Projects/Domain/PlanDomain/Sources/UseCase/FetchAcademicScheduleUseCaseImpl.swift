import Foundation
import PlanDomainInterface

public struct FetchAcademicScheduleUseCase: FetchAcademicScheduleUseCaseProtocol {
    private let repository: PlanRepository
    
    public init(repository: PlanRepository) {
        self.repository = repository
    }
    
    public func execute(date: String) async throws -> AcademicScheduleEntity {
        return try await repository.fetchAcademicScheduleByDate(date: date)
    }
}
