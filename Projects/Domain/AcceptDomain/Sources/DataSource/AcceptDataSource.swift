import Foundation

public protocol AcceptDataSource {
    func getAllApplications() async throws -> ApplicationListResponseDTO
}
