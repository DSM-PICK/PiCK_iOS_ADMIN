import Foundation

public protocol FetchMonthAcademicScheduleUseCaseProtocol {
    func execute(year: String, month: String) async throws -> AcademicScheduleEntity
}
