import Foundation

public protocol GetEarlyReturnUseCase {
    func execute(floor: Int, status: String) async throws -> [EarlyReturnEntity]
}
