import Foundation
import Combine
import PlanDomainInterface

public struct FetchAcademicScheduleUseCase: FetchAcademicScheduleUseCaseProtocol {
    private let repository: PlanRepository

    public init(repository: PlanRepository) {
        self.repository = repository
    }

    public func execute(date: String) -> AnyPublisher<AcademicScheduleEntity, Error> {
        repository.fetchAcademicScheduleByDate(date: date)
    }
}
