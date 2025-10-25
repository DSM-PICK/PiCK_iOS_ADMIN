import Foundation

public protocol AllTabDataSource {
    func getMyName() async throws -> MyNameResponseDTO
}
