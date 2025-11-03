import Foundation

public protocol FetchAcademicScheduleUseCaseProtocol {
    func execute(date: String) async throws -> AcademicScheduleEntity
}
