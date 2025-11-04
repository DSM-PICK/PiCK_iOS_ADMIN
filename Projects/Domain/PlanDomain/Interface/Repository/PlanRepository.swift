import Foundation

public protocol PlanRepository {
    func fetchAcademicScheduleByDate(date: String) async throws -> AcademicScheduleEntity
    func fetchMonthAcademicSchedule(year: String, month: String) async throws -> AcademicScheduleEntity
}
