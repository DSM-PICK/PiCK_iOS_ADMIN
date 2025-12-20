import Foundation
import Combine

public protocol FetchMonthAcademicScheduleUseCaseProtocol {
    func execute(year: String, month: String) -> AnyPublisher<AcademicScheduleEntity, Error>
}
