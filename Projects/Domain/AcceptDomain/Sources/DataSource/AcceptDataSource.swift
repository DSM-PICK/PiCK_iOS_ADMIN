import Foundation

public protocol AcceptDataSource {
    func getApplicationsByGrade(grade: Int, classNum: Int) async throws -> ApplicationListResponseDTO
    func updateApplicationStatus(status: String, idList: [String]) async throws
}
