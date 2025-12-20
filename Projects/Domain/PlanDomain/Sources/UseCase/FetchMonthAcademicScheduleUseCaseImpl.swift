import Foundation
import Combine
import PlanDomainInterface

public struct FetchMonthAcademicScheduleUseCase: FetchMonthAcademicScheduleUseCaseProtocol {
    private let repository: PlanRepository

    public init(repository: PlanRepository) {
        self.repository = repository
    }

    public func execute(year: String, month: String) -> AnyPublisher<AcademicScheduleEntity, Error> {
        repository.fetchMonthAcademicSchedule(year: year, month: month)
    }
}
