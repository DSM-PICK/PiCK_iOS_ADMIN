import Foundation

public protocol AcceptDataSource {
    func getApplicationsByGrade(grade: Int, classNum: Int) async throws -> ApplicationListResponseDTO
}
