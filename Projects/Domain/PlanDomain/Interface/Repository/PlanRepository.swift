import Foundation
import Combine

public protocol PlanRepository {
    func fetchAcademicScheduleByDate(date: String) -> AnyPublisher<AcademicScheduleEntity, Error>
    func fetchMonthAcademicSchedule(year: String, month: String) -> AnyPublisher<AcademicScheduleEntity, Error>
}
